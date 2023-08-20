FROM dart:2.19.6

COPY action_app/ /action_app/

RUN /bin/sh -c set -eux;

RUN cd /action_app \
    && dart pub get

ENV PATH /flutter/bin:$PATH

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

# Installing Flutter
RUN git clone -b 3.7.12 --depth 1 https://github.com/flutter/flutter.git /flutter \
    && flutter --version

ENTRYPOINT ["dart", "run", "/action_app/bin/main.dart"]
