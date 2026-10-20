# The full Bookworm image includes Debian's CA tooling and public trust store.
# Assemble trust without network operations before bootstrapping the slim image.
FROM node:24.22.0-bookworm AS trust

COPY .devcontainer/certs/ /usr/local/share/ca-certificates/
RUN update-ca-certificates

FROM node:24.22.0-bookworm-slim

ARG OPENCODE_VERSION=2.0.32

COPY .devcontainer/certs/ /usr/local/share/ca-certificates/

ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
COPY --from=trust /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git util-linux \
    && update-ca-certificates \
    && npm install --global --allow-scripts=@opencode/cli --prefix /opt/opencode "@opencode/cli@${OPENCODE_VERSION}" \
    && rm -rf /var/lib/apt/lists/*
RUN /opt/opencode/bin/opencode --version \
    && test "$(/opt/opencode/bin/opencode --version)" = "opencode v${OPENCODE_VERSION}"
RUN /opt/opencode/bin/opencode --help >/dev/null
RUN mkdir -p /usr/local/libexec/devcontainer /usr/local/sbin /home/node/.opencode-v2 \
    && chown root:root /home/node/.opencode-v2 \
    && chmod 0700 /home/node/.opencode-v2 \
    && rm -rf /var/lib/apt/lists/*

COPY .devcontainer/scripts/ /usr/local/libexec/devcontainer/
RUN chmod 0755 /usr/local/libexec/devcontainer/*.sh \
    && ln -s /usr/local/libexec/devcontainer/devcontainer-entrypoint.sh /usr/local/sbin/devcontainer-entrypoint \
    && ln -s /usr/local/libexec/devcontainer/opencode-container-auth.sh /usr/local/bin/opencode-container-auth \
    && ln -s /usr/local/libexec/devcontainer/opencode-wrapper.sh /usr/local/bin/opencode

ENV OPENCODE_V2_BINARY=/opt/opencode/bin/opencode
WORKDIR /workspaces/agentic-dev-template-2026
ENTRYPOINT ["/usr/local/sbin/devcontainer-entrypoint"]
CMD ["sleep", "infinity"]
