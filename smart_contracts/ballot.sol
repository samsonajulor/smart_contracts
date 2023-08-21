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

/*
 Implement the `giveRightToVote(address _voter)` function:
  - Verify `msg.sender` is the `chairperson`.
  - Check if `_voter` hasn't voted and doesn't have existing voting rights.
  - Assign a voting weight of 1 to `_voter` and update their voting status.
*/
 function giveRightTOVote(address _voter) public {
    require(msg.sender == chairperson, "Only chairperson can give right");
    require(voters[_voter].status == false, "Voter has voted");
    require(voters[_voter].weight == 1, "voter has right to vote");
    voters[_voter].weight = 1;
   // voters[_voter].status = true;
     }
/*
- Develop the `delegate(address _to)` function:
  - Require the sender to have voting rights, hasn't voted, and is not self-delegating.
  - Prevent circular delegation loops by tracking delegation paths.
  - Adjust vote counts based on the delegate's voting status.
*/
 function delegate(address _to) public  {
     require(voters[_to].weight == 1, "Has voting rights");
     require(voters[_to].status == false, "Has voted");
     require(msg.sender != _to, "do not self delegate");
      Voter storage sender = voters[msg.sender]; 

      sender.delegate = _to;
      //Voter storage delegate = voters[_to];
      voters[_to].weight += sender.weight;

      //delegate.weight += sender.weight;


 }
 /*
 Create the `vote(uint256 _proposalIndex)` function:
  - Require the sender to have voting rights and hasn't voted.
  - Increment the vote count for the chosen proposal index.
  - Record the vote and update the sender's voting status.
 */
 function vote(uint256 _proposalIndex) public {
     Voter storage sender = voters[msg.sender]; 
     require(sender.weight == 0, "Does not have voting rights");
     require(sender.status == false, "This sender has voted");
       proposals[_proposalIndex].voteCount++;
      sender.status == true; 
       //proposals[_proposalIndex].status == true;
       sender.index = _proposalIndex;

 }
}
