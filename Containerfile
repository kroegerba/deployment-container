FROM node:22

WORKDIR /work

RUN useradd -m builder && chown -R builder:builder /work

COPY entrypoint.sh /work/entrypoint.sh
RUN sed -i 's/\r$//' /work/entrypoint.sh
RUN chmod 755 /work/entrypoint.sh
RUN chmod +x /work/entrypoint.sh

USER builder

ENTRYPOINT ["/work/entrypoint.sh"]
CMD ["bash"]
