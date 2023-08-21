// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Ballot {
    struct Voter{
      uint weight; 
      bool status;  
      address delegate; 
      uint index;    
    }

    struct Proposal{
        bytes32 name;
        uint voteCount;
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

}