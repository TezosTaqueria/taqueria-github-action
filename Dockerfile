
FROM debian:bullseye
FROM node:16.13

# Set the DENO_DIR environment variable to controll where the cache is built
RUN mkdir deno
ENV DENO_DIR=/deno

COPY --from=docker:dind /usr/local/bin/docker /bin/docker

# Download the Taqueria release binary for Linux to /bin/taq
# TODO: this should be changed to accept the variable as an argument unless this docker file ends
# TODO: unless the docker file ends up in the taqueria/taqueria repository
ADD https://github.com/ecadlabs/taqueria/releases/download/v0.3.0/taq-linux /bin/taq
# ADD https://storage.googleapis.com/taqueria-artifacts/refs/pull/704/merge/1e14791c55d5d771496e7c4ad136eee952213c6b/taq.x86_64-unknown-linux-gnu /bin/taq
# ADD https://storage.googleapis.com/taqueria-artifacts/refs/pull/704/merge/1550968cebac0300fa42b69038cd3ab708abe718/taq.x86_64-unknown-linux-gnu /bin/taq

# Make the binary executable
RUN chmod +x /bin/taq

ENV PATH="/bin:{$PATH}"

# COPY entrypoint.sh /bin/entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# TODO: surpress the npm notice for new versions
# TODO: we potentially need a default project with all of the dependencies already installed if this dockerfile is used for the the GitHub action
