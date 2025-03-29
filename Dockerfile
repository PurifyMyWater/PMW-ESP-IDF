FROM espressif/idf:release-v5.4
LABEL authors="Purify my Water team" \
      description="Espressif IDF Docker image with qemu & pytests" \
      version="0.0.1"

## Install QEMU
#RUN apt-get update && apt-get install -y libgcrypt20 libglib2.0-0 libpixman-1-0 libsdl2-2.0-0 libslirp0
#RUN python $IDF_PATH/tools/idf_tools.py install qemu-xtensa qemu-riscv32

# Install pytest
RUN bash $IDF_PATH/install.sh --enable-pytest

ENTRYPOINT ["/opt/esp/entrypoint.sh"]
