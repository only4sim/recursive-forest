const ethers = require('ethers');
const { abi } = require('./compile');
const fs = require('fs');

// Configuring the Blockchain Network
const providerRPC = {
  development: {
    name: 'moonbeam-development',
    rpc: 'http://localhost:9944',
    chainId: 1281,
  },
  moonbase: {
    name: 'moonbase-alpha',
    rpc: 'https://moonbase-alpha.public.blastapi.io',
    chainId: 1287,
  },
  zkEVM_Testnet	: {
    name: 'zkEVM-Testnet',
    rpc: 'https://rpc.public.zkevm-test.net',
    chainId: 1442,
  },
};
const provider = new ethers.providers.JsonRpcProvider(providerRPC.moonbase.rpc, {
  chainId: providerRPC.zkEVM_Testnet.chainId,
  name: providerRPC.zkEVM_Testnet.name,
}); // Change to correct network

// Configure wallet accounts and contracts
const account_from = {
  privateKey: 'YOUR_PRIVATE_KEY',
};
const contractAddress = 'verifier.sol';
const _value = 3;

// Read in the proof JSON file
const proof_source = fs.readFileSync('proof.json', 'utf8');

// Create a wallet
let wallet = new ethers.Wallet(account_from.privateKey, provider);

// Build a contract instance.
const contract = new ethers.Contract(contractAddress, abi, wallet);

// Invocation proof
const increment = async () => {
  console.log(
    `Calling the increment by ${_value} function in contract at address: ${contractAddress}`
  );


  proof = JSON.parse(proof_source);
  // console.log(proof);
  // console.log(abi);
    
  // Constructing the proof object, this part does not need to be changed in most cases and is generic
  const inputStruct = {
    a: {
      X: ethers.BigNumber.from(proof.proof.a[0]),
      Y: ethers.BigNumber.from(proof.proof.a[1]),
    },
    b: {
      X: [ethers.BigNumber.from(proof.proof.b[0][0]), ethers.BigNumber.from(proof.proof.b[0][1])],
      Y: [ethers.BigNumber.from(proof.proof.b[1][0]), ethers.BigNumber.from(proof.proof.b[1][1])],
    },
    c: {
      X: ethers.BigNumber.from(proof.proof.c[0]),
      Y: ethers.BigNumber.from(proof.proof.c[1]),
    }
  }

  // Call the verification
  const createReceipt =  await contract.verifyTx(inputStruct, [ethers.BigNumber.from(proof.inputs[0])]);

  console.log(createReceipt);
  // await createReceipt.wait();
  // console.log(`Tx successful with hash: ${createReceipt.hash}`);
};

increment();