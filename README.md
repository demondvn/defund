# defund
defund node
build on https://nodes.guru/defund/setup-guide/en

      mkdir defund && cd defund 
      wget https://raw.githubusercontent.com/defund-labs/testnet/main/defund-private-4/genesis.json
      seeds ="9f92e47ea6861f75bf8a450a681218baae396f01@94.130.219.37:26656,f03f3a18bae28f2099648b1c8b1eadf3323cf741@162.55.211.136:26656,f8fa20444c3c56a2d3b4fdc57b3fd059f7ae3127@148.251.43.226:56656,70a1f41dea262730e7ab027bcf8bd2616160a9a9@142.132.202.86:17000,e47e5e7ae537147a23995117ea8b2d4c2a408dcb@172.104.159.69:45656,74e6425e7ec76e6eaef92643b6181c42d5b8a3b8@defund-testnet-seed.itrocket.net:443"

      sed -i "s/^seeds *=.*/seeds = \"$seeds\"/" config/config.toml
      sed -i.default -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025ufetf\"/" config/app.toml    
      sed -i "s/pruning *=.*/pruning = \"custom\"/g" config/app.toml
      sed -i "s/pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/g" config/app.toml
      sed -i "s/pruning-interval *=.*/pruning-interval = \"10\"/g" config/app.toml
 
 ##RUN
      docker run -it -d -v defund/:/root/.defund -p 26656:26656 --name defund defund
