# Base image
FROM miktex/miktex:basic

# Run updates and install necessary packages
RUN apt-get update && \
    apt-get install -y perl && \
    apt-get clean && \
    mpm --update

# Set the environment variable for MIKTEX_UID
ENV MIKTEX_UID 1000