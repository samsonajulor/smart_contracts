// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
    Ballot Smart Contract
    @Author: Web3Bridge Cohort9
    @Date: 2023/08/20
    @Instructions: Please add comments to each line of code explaining what the code is doing
*/
contract Ballot {
    struct Voter {
        uint weight;
        bool hasVoted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        bytes name;
        uint voteCount;
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    constructor() {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
    }

    // This modifier sends reward to the voter if they vote successfully
    modifier sendReward() {
        uint256 rewardAmount = 610000000000000; // 0.00061 Ether in Wei
        _;
        payable(msg.sender).transfer(rewardAmount);
    }


    function giveRightToVote(address _voter) public {
        require(msg.sender == chairperson, "Only chairperson has access"); // Verify `msg.sender` is the `chairperson`
        require(!voters[_voter].hasVoted, "The voter already voted"); // Check if `_voter` hasn't voted
        require(voters[_voter].weight == 0, "Voter can't vote"); // Check if `voter` doesn't have existing voting rights
        voters[_voter].weight = 1; // Assign a voting weight of 1 to `_voter` and update their voting status
    }

    function delegate(address _to) public {
        Voter storage sender = voters[msg.sender];

        require(sender.weight > 0, "sender doesnt have voting rights"); // Require the sender to have voting rights
        require(!sender.hasVoted, "sender has already voted"); // Require the sender hasn't voted
        require(_to != msg.sender, "self delegating isn't allowed!!!"); // Require the sender is not self-delegating

        // Adjust vote counts based on the delegate's voting status
        // !sender.hasVoted; // this is not needed as it is already checked above
        sender.delegate = _to; // Set the sender's delegate to the `_to` address
        Voter storage delegate_ = voters[_to]; // The delegate is a voter as well.
        if (delegate_.hasVoted) {
            proposals[delegate_.vote].voteCount += sender.weight; // If the delegate has voted, increment the proposal's vote count directly
        } else {
            delegate_.weight += sender.weight; // If the delegate hasn't voted, increment the delegate's weight
        }
        sender.weight = 0; //reset the senders weight back to 0;
    }

    function withdrawDelegation() public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight > 0, "sender doesnt have voting rights"); // Require the sender to have voting rights
        require(!sender.hasVoted, "sender has already voted"); // Require the sender hasn't voted

        address _to = sender.delegate; // Set the `_to` address to the sender's delegate
        require(_to != msg.sender, "self de-delegating isn't allowed!!!"); // Require the sender is not self-de-delegating

        sender.weight = voters[_to].weight; // Set the sender's weight to the delegate's weight
        voters[_to].weight -= sender.weight; // reduce the delegate's weight by the sender's weight
        sender.delegate = address(0); // Set the sender's delegate to 0
    }

    function vote(uint256 _proposalIndex) public sendReward() {
        Voter storage sender = voters[msg.sender];
        require(sender.weight > 0, "voter has no right to vote"); // Require the sender to have voting rights
        require(!sender.hasVoted, "voter has already voted"); // Require the sender to hasn't voted

        // Increment the vote count for the chosen proposal index
        // Record the vote and update the sender's voting status.
        sender.vote = _proposalIndex; // Set the sender's vote to the `_proposalIndex` value. This is the proposal they are voting for
        proposals[_proposalIndex].voteCount += sender.weight; // Increment the proposal's vote count by the sender's weight
        sender.weight = 0; // Reset the sender's weight to 0 to prevent double voting
        sender.hasVoted = true; // Set the sender's voting status to true
    }

    function addProposal(string memory _name) public {
        bytes memory strToBytes = bytes(_name); // typescast string to bytes
        proposals.push(Proposal({name: strToBytes, voteCount: 0})); // push the created proposal to the array
    }

    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0; // initialize the winning vote to zero
        for (uint prop = 0; prop < proposals.length; prop++) {
            // loop throught the proposal array
            if (proposals[prop].voteCount > winningVoteCount) {
                // check if the proposal voteCount is grater than winningVoteCount
                winningVoteCount = proposals[prop].voteCount; // set the winningVoteCount equal to the proposal with highest count
                winningProposal_ = prop; // return the winning voteCount
            }
        }
    }

    function winningProposalName () public view returns (bytes memory winningProposalName_) {
        winningProposalName_ = proposals[winningProposal()].name; // return the winningProposal name from the winningProposal voteCount function
    }
    
    function addProposals(string[] memory _names) public {
    require(msg.sender == chairperson, "Only chairperson can add proposals");

    for (uint i = 0; i < _names.length; i++) {
        bytes memory strToBytes = bytes(_names[i]);
        proposals.push(Proposal({name: strToBytes, voteCount: 0}));
    }
}


}
