FROM node:22

WORKDIR /work

RUN useradd -m builder && chown -R builder:builder /work

USER builder
