const { Web3 } = require("web3");
const web3 = new Web3("http://127.0.0.1:8545/"); // Replace with your Ethereum node URL

const { abi } = require("../build/contracts/Voting.json");

const contractAddress = "0xfcf6d14E948F5359Fab97401AA1D04fe5230D0eA"; // Replace with the deployed contract address

const contract = new web3.eth.Contract(abi, contractAddress);

async function getVoteCount() {
  const voteCounts = await contract.methods.voteCount().call();

  console.log("Vote Counts:", voteCounts);
}

async function performVote() {
  const voteData = [0, 1];
  const accounts = await web3.eth.getAccounts();
  const txObject = {
    from: accounts[1],
    gasLimit: 6721975,
  };
  await contract.methods.performVote(voteData).send(txObject);
  await contract.methods.performVote(voteData).send(txObject);
  await contract.methods.performVote(voteData).send(txObject);
  await contract.methods.performVote(voteData).send(txObject);

  console.log("Vote recorded successfully!");
}

// Use the functions to interact with the contract
performVote();
getVoteCount();
