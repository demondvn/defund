FROM ubuntu:20.04

RUN apt update && apt install -y curl make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop && \
    curl -s https://api.nodes.guru/logo.sh | bash

ENV DEFUND_NODENAME "MonPham"
ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV GO111MODULE on
ENV PATH $PATH:/usr/local/go/bin:/root/go/bin

RUN wget -O go1.19.1.linux-amd64.tar.gz https://golang.org/dl/go1.19.1.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz && rm go1.19.1.linux-amd64.tar.gz && \
    git clone https://github.com/defund-labs/defund && \
    cd defund && \
    git checkout v0.2.2 && \
    make build && \
    mv ./build/defundd /usr/local/bin/

WORKDIR /root

RUN read -p "Enter node name: " DEFUND_NODENAME && \
    echo 'export DEFUND_NODENAME='\"${DEFUND_NODENAME}\" >> ~/.bashrc && \
    echo 'source ~/.bashrc' >> ~/.bash_profile && \
    . ~/.bash_profile && \
    defundd init "$DEFUND_NODENAME" --chain-id=defund-private-4"

ENV seeds "9f92e47ea6861f75bf8a450a681218baae396f01@94.130.219.37:26656,f03f3a18bae28f2099648b1c8b1eadf3323cf741@162.55.211.136:26656,f8fa20444c3c56a2d3b4fdc57b3fd059f7ae3127@148.251.43.226:56656,70a1f41dea262730e7ab027bcf8bd2616160a9a9@142.132.202.86:17000,e47e5e7ae537147a23995117ea8b2d4c2a408dcb@172.104.159.69:45656,74e6425e7ec76e6eaef92643b6181c42d5b8a3b8@defund-testnet-seed.itrocket.net:443"

RUN sed -i "s/^seeds *=.*/seeds = \"$seeds\"/" ~/.defund/config/config.toml
RUN sed -i.default -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025ufetf\"/" ~/.defund/config/app.toml
RUN sed -i "s/pruning *=.*/pruning = \"custom\"/g" ~/.defund/config/app.toml
RUN sed -i "s/pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/g" ~/.defund/config/app.toml
RUN sed -i "s/pruning-interval *=.*/pruning-interval = \"10\"/g" ~/.defund/config/app.toml
RUN wget -O ~/.defund/config/genesis.json https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-4/genesis.json
RUN defundd tendermint unsafe-reset-all
VOLUME ~/.defund/
ENTRYPOINT ["defundd", "start"]
