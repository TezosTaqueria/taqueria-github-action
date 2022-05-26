
FROM debian:bullseye
FROM node:16.13

# Set the DENO_DIR environment variable to controll where the cache is built
RUN mkdir deno
ENV DENO_DIR=/deno

COPY --from=docker:dind /usr/local/bin/docker /bin/docker

# Download the Taqueria release binary for Linux to /bin/taq
# TODO: this should be changed to accept the variable as an argument unless this docker file ends
# TODO: unless the docker file ends up in the taqueria/taqueria repository
ADD https://github.com/ecadlabs/taqueria/releases/download/v0.3.1/taq-linux /bin/taq

# Make the binary executable
RUN chmod +x /bin/taq

ENV PATH="/bin:{$PATH}"

COPY entrypoint.sh /entrypoint.sh
# Uncomment below for running locally
# RUN chown -R 1000:998 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# TODO: surpress the npm notice for new versions
# TODO: we potentially need a default project with all of the dependencies already installed if this dockerfile is used for the the GitHub action
