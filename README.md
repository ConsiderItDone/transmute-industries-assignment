## Integration tests for Oraclize

### How to run

```bash
./start.sh
```

### How it works

* start with `docker-composer` instance of `geth` and `ethereum-bridge`
* build docker image with truffle test
* wait for ethereum network to setup
* extract Oraclize Address Resolver (OAR) from `ethereum-bridge` config
* pass this address as ENV variable to truffle docker image and run test