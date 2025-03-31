FROM espressif/idf:release-v5.4
LABEL authors="Purify my Water team" \
      description="Espressif IDF Docker image with qemu & pytests" \
      version="0.0.1"

## Update dependencies
RUN apt-get update && apt-get upgrade -y

# Install pytest
RUN bash $IDF_PATH/install.sh --enable-pytest

ENTRYPOINT ["/opt/esp/entrypoint.sh"]
