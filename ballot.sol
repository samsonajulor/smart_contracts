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

    event voteRecorded (address delegate, uint vote); 


    function giveRightToVote(address _voter) public view {
        require(msg.sender == chairperson);
        (uint _weight, bool _status) = (voters[msg.sender].weight, voters[msg.sender].status);
        require (_weight == 0 || !_status, "address is a voter or has already voted");
        require(voters[_voter].weight < 1, "address has not voted");
        require(voters[_voter].weight == 1, "address has voted");
    }

    function delegate(address _to) public {
        (uint _weight, bool _status) = (voters[msg.sender].weight, voters[msg.sender].status);
        Voter storage sender  = voters[msg.sender];
        Voter storage _delegate = voters[_to];
        require (_to != msg.sender, "Self Delegating not allowed");
        require (_weight == 1, "Msg.sender lacks voting rights");
        require (!_status, "msg.sender has voted");
        _delegate.weight = sender.weight;
        sender.weight = 0;
        
    }

    function vote(uint256 _proposalIndex) public {
        (uint _weight, bool _status) = (voters[msg.sender].weight, voters[msg.sender].status);
        Proposal memory _proposal = proposals[_proposalIndex];
        require(_weight == 1, "Msg.sender has voting rights");
        require(_status, "msg.sender has voted");
        _proposal.voteCount += 1;
        emit voteRecorded(msg.sender, _proposal.voteCount);
    }
}
