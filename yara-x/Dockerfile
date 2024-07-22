# Start with a Rust base image
FROM rust:latest

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    git \
    gosu \
    tini

# Clone yara-x repository
RUN git clone https://github.com/VirusTotal/yara-x.git

# Set the working directory
WORKDIR /yara-x

# Build yara-x
RUN cargo build

# Add yara-x to PATH
ENV PATH="/yara-x/target/debug:${PATH}"

# Create a non-root user
RUN useradd -m dockeruser

# Set up volumes
VOLUME ["/malware"]
VOLUME ["/rules"]

# Set the working directory for the entrypoint
WORKDIR /malware

# Set the entrypoint
ENTRYPOINT ["gosu", "dockeruser", "/usr/bin/tini", "--", "yr"]