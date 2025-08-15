FROM espressif/idf:v5.5
LABEL authors="purifymywater" \
      description="Espressif IDF Docker image with qemu & pytests" \
      version="v5.5"

## Update dependencies
RUN apt-get update && apt-get upgrade -y

## Install CLion devcontainer dependency
RUN apt-get install libicu-dev -y

# Install pytest
RUN bash $IDF_PATH/install.sh --enable-pytest

ENTRYPOINT ["/opt/esp/entrypoint.sh"]
