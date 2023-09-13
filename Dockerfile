FROM dart:stable

COPY action_app/ /action_app/

RUN /bin/sh -c set -eux;

RUN cd /action_app \
    && dart pub get

ENV PATH /flutter/bin:$PATH

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone \
    -b $flutter_version \
    --depth 1 \
    https://github.com/flutter/flutter.git \
    /flutter \
  && flutter --version

ENTRYPOINT ["dart", "run", "/action_app/bin/main.dart"]
