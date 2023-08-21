// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
/*
    Ballot Smart Contract
    @Author: Web3Bridge Cohort9
    @Date: 2021/07/10
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
        bytes32 name;
        uint voteCount;
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    constructor() {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
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
    }

    function vote(uint256 _proposalIndex) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight > 0, "voter has no right to vote"); // Require the sender to have voting rights
        require(!sender.hasVoted, "voter has already voted"); // Require the sender to hasn't voted

        // Increment the vote count for the chosen proposal index
        // Record the vote and update the sender's voting status.
        sender.vote = _proposalIndex; // Set the sender's vote to the `_proposalIndex` value. This is the proposal they are voting for
        proposals[_proposalIndex].voteCount += sender.weight; // Increment the proposal's vote count by the sender's weight
        sender.weight = 0; // Reset the sender's weight to 0 to prevent double voting 
        if (sender.vote > 0) {
            sender.hasVoted = true; // Set the sender's voting status to true
        }
    }
}
