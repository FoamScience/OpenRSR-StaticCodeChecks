FROM foamscience/bionic-openfoam7

RUN export DEBIAN_FRONTEND=noninteractive; apt update && apt-get install -q -y \
        clang clang-tidy build-essential curl doxygen gcc-multilib \
        git python-virtualenv python3-dev postgresql \
    && apt clean

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt install -y nodejs && apt clean

RUN git clone https://github.com/Ericsson/CodeChecker --depth 1 /codechecker

RUN cd /codechecker && make venv \
    && bash -c 'source /codechecker/venv/bin/activate && make package'

ENV PATH="/codechecker/build/CodeChecker/bin:${PATH}"
RUN mkdir -m 777 /.codechecker

RUN bash -c 'echo "source /codechecker/venv/bin/activate" >> ~/.profile' \
    && bash -c 'echo "source /opt/openfoam7/etc/bashrc" >> ~/.profile'

COPY parse_url.py .
ENV DB_CMD=`./parse_url.py`
ENV PGPASSFILE="/.pgpass"
RUN apt install postgresql-server-dev-all -y -q
RUN bash -c 'source /codechecker/venv/bin/activate; pip install psycopg2'

CMD bash -l -c \
    "./parse_url.py --passfile > /.pgpass && source /codechecker/venv/bin/activate && CodeChecker server --host 0.0.0.0 --port $PORT $DB_CMD"
