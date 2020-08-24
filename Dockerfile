FROM foamscience/bionic-openfoam7

RUN apt install -y \
        clang clang-tidy build-essential curl doxygen gcc-multilib \
        git python-virtualenv python3-dev \
    && apt clean

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN git clone https://github.com/Ericsson/CodeChecker.git --depth 1 ~/codechecker

RUN apt install -y nodejs && apt clean

RUN cd ~/codechecker && make venv \
    && source ~/codechecker/venv/bin/activate \
    && make package

ENV PATH="~/codechecker/build/CodeChecker/bin:${PATH}"

RUN bash -c 'source ~/codechecker/venv/bin/activate >> ~/.bashrc' \
    && bash -c 'source /opt/openfoam7/etc/bashrc >> ~/.bashrc' \
    && bash -c 'CodeChecker server --port 80'
