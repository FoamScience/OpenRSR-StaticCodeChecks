FROM foamscience/bionic-openfoam7

RUN apt update && apt install -y \
        clang clang-tidy build-essential curl doxygen gcc-multilib \
        git python-virtualenv python3-dev \
    && apt clean

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs && apt clean

RUN git clone https://github.com/Ericsson/CodeChecker --depth 1 /codechecker

RUN cd /codechecker && make venv \
    && bash -c 'source /codechecker/venv/bin/activate && make package'

ENV PATH="/codechecker/build/CodeChecker/bin:${PATH}"

RUN bash -c 'echo "source /codechecker/venv/bin/activate" >> ~/.profile' \
    && bash -c 'echo "source /opt/openfoam7/etc/bashrc" >> /.profile'

COPY parse_url.py .
ENV DB_CMD=`./parse_url.py`
RUN bash -c 'source /codechecker/venv/bin/activate; pip install pg8000'

CMD bash -l -c \
    "source /codechecker/venv/bin/activate; CodeChecker server --port $PORT `./parse_url.py`"
