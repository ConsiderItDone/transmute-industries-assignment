module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    "docker": {
        host: process.env.ETH_HOST,
        port: 8545,
        network_id: "*" // Match any network id
    }
  }
};
