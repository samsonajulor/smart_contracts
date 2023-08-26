// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// *Question: Account Payment System*

// You are tasked with creating a Solidity smart contract for an account payment system.
// Each account is identified by an Ethereum address and has a unique ID.
// The contract owner has the authority to add funds, deduct funds, and check balances for accounts. Implement the contract as described below:

// solidity
// pragma solidity ^0.8.0;

// contract AccountPaymentSystem {
//     address public owner;
    
//     struct Account {
//         uint id;
//         uint balance;
//         bool exists;
//     }
    
//     mapping(address => Account) private accounts;
    
//     modifier onlyOwner() {
//         // Implement the modifier to allow only the contract owner to proceed.
//         // HINT: You can use 'require' to check if the sender is the owner.
//         _;
//     }
    
//     constructor() {
//         // Initialize the contract owner.
//         // HINT: You can use 'msg.sender' to set the owner.
//     }
    
//     function addAccount(address _accountAddress, uint _accountId) public onlyOwner {
//         // Add a new account with the given address and ID.
//         // Set the initial balance to 0 and 'exists' to true.
//     }
    
//     function depositFunds(address _accountAddress, uint _amount) public onlyOwner {
//         // Deposit the given amount of funds to the account's balance.
//         // Ensure the account exists before updating the balance.
//     }
    
//     function deductFunds(address _accountAddress, uint _amount) public onlyOwner {
//         // Deduct the given amount of funds from the account's balance.
//         // Ensure the account exists and has enough balance for the deduction.
//     }
    
//     function getBalance(address _accountAddress) public view returns (uint) {
//         // Retrieve the balance of the account with the given address.
//         // Return 0 if the account does not exist.
//     }
// }


// In this question, you'll create a Solidity contract that manages account balances. The contract owner can add funds, deduct funds, and check balances for accounts. The `exists` field in the `Account` struct indicates whether an account's information has been added.

// ---

// Feel free to provide additional information as needed.


contract AccountPaymentSystem {
   address public owner;
    
    struct Account {
        uint id;
        uint balance;
        bool exists;
    }
    
    mapping(address => Account) private accounts;

    modifier onlyOwner() {
        require(msg.sender == owner,
        "Only owner is required to call this");
        _;
    }
    constructor() {
        owner = msg.sender;
    }
 function addAccount(address _addr, uint _id) public onlyOwner{
    Account storage account = accounts[_addr];
    accounts[_addr].id = _id;
   // account.id = _id;
   accounts[_addr].balance = 0;
    account.balance = 0;
    account.exists = true;
 }
//   function addAccount(address _accountAddress, uint _accountId) public onlyOwner {
//         // Add a new account with the given address and ID.
//         // Set the initial balance to 0 and 'exists' to true.
//     }


 function depositFunds(address _addr, uint _amount) public onlyOwner {
        // Deposit the given amount of funds to the account's balance.
        require(accounts[_addr].exists != true, "Account doesn't exist");
        accounts[_addr].balance += _amount; 
        // Ensure the account exists before updating the balance.
    }
function deductFunds(address _addr, uint _amount) public onlyOwner {
        // Ensure the account exists and has enough balance for the deduction.
        require(accounts[_addr].exists == true, "Account does not exist");
        require(accounts[_addr].balance <= _amount, "Insufficient Balance");
        // Deduct the given amount of funds from the account's balance.
        accounts[_addr].balance -= _amount;

    }
function getBalance(address _addr) public view returns (uint) {
        // Retrieve the balance of the account with the given address.

        // Return 0 if the account does not exist.
        if(accounts[_addr].exists == false ) {
            return 0;
        }
      return 
     accounts[_addr].balance;

    }

 }