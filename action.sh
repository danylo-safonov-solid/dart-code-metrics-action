git clone \
    -b $1 \
    --depth 1 \
    https://github.com/flutter/flutter.git \
    /flutter \
  && flutter --version

dart run /action_app/bin/main.dart
