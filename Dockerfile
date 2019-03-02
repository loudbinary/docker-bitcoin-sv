FROM debian:sid as builder

RUN apt-get update && apt-get install -y curl

ENV BSV_VERSION=0.1.1
ENV BSV_CHECKSUM="6a537c7b050594c3f4e674abfd925dfdf6d267af530a83581354362589dcfb79 bitcoin-sv-${BSV_VERSION}-x86_64-linux-gnu.tar.gz"
RUN echo "Expecting Checksum equal to: ${BSV_CHECKSUM}"
RUN curl -SLO "https://github.com/bitcoin-sv/bitcoin-sv/releases/download/v${BSV_VERSION}/bitcoin-sv-${BSV_VERSION}-x86_64-linux-gnu.tar.gz" \
  && echo "${BSV_CHECKSUM}" | sha256sum -c - | grep OK \
  && tar -xzf bitcoin-sv-${BSV_VERSION}-x86_64-linux-gnu.tar.gz

FROM debian:sid-slim
ENV BSV_VERSION=0.1.1
RUN useradd -m bitcoin
USER bitcoin
COPY --from=builder /bitcoin-sv-${BSV_VERSION}/bin/bitcoind /bin/bitcoind
RUN mkdir -p /home/bitcoin/.bitcoin
ENTRYPOINT ["bitcoind"]
