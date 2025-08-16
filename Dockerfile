# =================================================================
# Stage 1: The Preparer
#
# Clones the ESP-IDF source using the provided arguments and then
# removes all Git history to reduce the final image size.
# =================================================================
FROM espressif/idf:v5.5 AS preparer

# The final location for the IDF source code
ENV IDF_PATH=/opt/esp/idf

# IMPORTANT: Find and delete all .git directories to create a clean source tree
RUN find $IDF_PATH -type d -name ".git" | xargs rm -rf


# =================================================================
# Stage 2: The Final Image
#
# This stage builds the complete, minimal ESP-IDF development
# environment on Debian Linux.
# =================================================================
FROM debian:bookworm-slim AS runner

LABEL authors="purifymywater" \
      description="Espressif IDF Docker image with qemu & pytests" \
      version="v5.5"

# Re-declare ARGs needed in this stage
ARG IDF_INSTALL_TARGETS=all

# Set standard environment variables
ENV IDF_PATH=/opt/esp/idf
ENV DEBIAN_FRONTEND=noninteractive

# STEP 2: Install Debian equivalents of the packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        bison \
        bzip2 \
        ca-certificates \
        ccache \
        check \
        curl \
        flex \
        git \
        git-lfs \
        libglib2.0-dev \
        gperf \
        lcov \
        libbsd-dev \
        libffi-dev \
        libslirp-dev \
        libusb-1.0-0-dev \
        make \
        libncurses-dev \
        ninja-build \
        libpixman-1-dev \
        python3 \
        python3-virtualenv \
        python3-venv \
        python-is-python3 \
        ruby \
        libsdl2-dev \
        unzip \
        wget \
        xz-utils \
        zip \
        build-essential \
        libicu-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# STEP 3: Copy the clean ESP-IDF source from the preparer stage
COPY --from=preparer $IDF_PATH $IDF_PATH

# STEP 4: Install the ESP-IDF toolchain using the install.sh script
# This will now work correctly on the glibc-based system.
RUN sh $IDF_PATH/install.sh $IDF_INSTALL_TARGETS --enable-pytest

# Add get_idf as alias
RUN echo 'alias get_idf=". /opt/esp/idf/export.sh"' >> /root/.bashrc

# Set up the entrypoint
COPY --from=preparer /opt/esp/entrypoint.sh /opt/esp/entrypoint.sh
RUN chmod +x /opt/esp/entrypoint.sh
ENTRYPOINT [ "/opt/esp/entrypoint.sh" ]
