// deploy code will go here
const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");
const { interface, bytecode } = require("./compile");

const provider = new HDWalletProvider(
  "frame wool share waste scare vivid fade link kite side poet about",
  // remember to change this to your own phrase!
  "https://rinkeby.infura.io/v3/3751b5f38fca4a718859e6760905f4a8"
  // remember to change this to your own endpoint!
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log("Attempting to deploy from account", accounts[0]);

  const result = await new web3.eth.Contract(JSON.parse(interface))
    // .deploy({ data: bytecode, arguments: ["Hi there!"] })
    .deploy({ data: bytecode })
    .send({ gas: "4700000", from: accounts[0] });
  console.log("Contract deployed to", result.options.address);
  console.log("interface", interface);
  provider.engine.stop();
};
deploy();
