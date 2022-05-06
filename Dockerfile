
FROM debian:bullseye
FROM node:16.13

# Set the DENO_DIR environment variable to controll where the cache is built
RUN mkdir taqueria deno
ENV DENO_DIR=/deno

COPY --from=docker:dind /usr/local/bin/docker /bin/docker

# Download the Taqueria release binary for Linux to /bin/taq
# TODO: this should be changed to accept the variable as an argument unless this docker file ends
# TODO: unless the docker file ends up in the taqueria/taqueria repository
ADD https://github.com/ecadlabs/taqueria/releases/download/v0.3.0/taq-linux /bin/taq

# Make the binary executable
RUN chmod +x /bin/taq

# Change ownership of key files and folders to the user with id 1000 and switch users. This does not work with github-actions
# RUN chown --recursive 1000:1000 \
#     /bin/taq \
#     /deno \
#     /taqueria
# USER 1000:998

# Set user and group to runner:docker
USER 1001:121

# ENTRYPOINT [ "/bin/taq" ]

ENV PATH="/bin:{$PATH}"

COPY entrypoint.sh /bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]

# TODO: surpress the npm notice for new versions
# TODO: we potentially need a default project with all of the dependencies already installed if this dockerfile is used for the the GitHub action
