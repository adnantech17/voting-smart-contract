const { Web3 } = require("web3");
const web3 = new Web3("http://127.0.0.1:8545/"); // Replace with your Ethereum node URL

const { abi } = require("../build/contracts/Keydistribution.json");

const contractAddress = "0x7fbE4a85C0C27202734DA87F36EBE3925A53C9e9"; // Replace with the deployed contract address

const contract = new web3.eth.Contract(abi, contractAddress);

async function getKey() {
  try {
    // Replace with your Ethereum account address
    const senderAddress = '0xe26e68Bd644543A419BB8e9c9C822061F8DEe2F3';

    // Call the getKey function
    const result = await contract.methods.getKey().call({ from: senderAddress });

    return `Key Obtained: ${result}`;
  } catch (error) {
    console.error(`An error occurred: ${error.message}`);
    return 'Transaction failed';
  }
}

// Call the getKey function
getKey()
  .then(result => console.log(result))
  .catch(error => console.error(error));
