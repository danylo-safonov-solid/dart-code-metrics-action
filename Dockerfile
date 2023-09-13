FROM dart:stable

COPY action_app/ /action_app/

RUN /bin/sh -c set -eux;

RUN cd /action_app \
    && dart pub get

ENV PATH /flutter/bin:$PATH

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

# Installing Flutter
RUN git clone -b stable --depth 1 https://github.com/flutter/flutter.git /flutter \
    && cd /flutter \
    && git checkout 3.10.6 \
    && cd .. \
    && flutter --version

ENTRYPOINT ["dart", "run", "/action_app/bin/main.dart"]
