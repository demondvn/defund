# defund
defund node
build on https://nodes.guru/defund/setup-guide/en

      mkdir defund && cd defund 
      wget https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-4/genesis.json
      docker run -it -d -v defund/:/root/.defund -p 26656:26656 --name defund defund
