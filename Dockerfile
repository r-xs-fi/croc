FROM alpine:latest

# can't have default values here, otherwise they'd overwrite the buildx-supplied ones
ARG TARGETOS
ARG TARGETARCH

WORKDIR /workspace

ENTRYPOINT ["/usr/bin/croc"]

# /.config because Croc wants to write some config files and I'm too lazy to set up ENVs in such a way
# that it would point in actual home directory (which we'd have to create also)
RUN mkdir /tmp/install \
	&& cd /tmp/install \
	&& wget -O dummy.tar.gz "https://function61.com/app-dl/api/github.com/schollz/croc/latest_releases_asset/__autodetect__.tar.gz?os=$TARGETOS&arch=$TARGETARCH" \
	&& tar -xzf *.tar.gz \
	&& mv croc /usr/bin/ \
	&& rm -rf /tmp/install \
	&& mkdir /.config && chmod 777 /.config

# run as unprivileged user
USER 1000:1000
