import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import BallotContract from './contracts/Ballot.json';

interface Proposal {
  name: string;
  voteCount: number;
}

const App: React.FC = () => {
  const [provider, setProvider] = useState<ethers.providers.Web3Provider | null>(null);
  const [contract, setContract] = useState<ethers.Contract | null>(null);
  const [account, setAccount] = useState<string | null>(null);
  const [voterAddress, setVoterAddress] = useState<string>('');
  const [proposalName, setProposalName] = useState<string>('');
  const [proposals, setProposals] = useState<Proposal[]>([]);
  const [selectedProposalIndex, setSelectedProposalIndex] = useState<number | null>(null);

  useEffect(() => {
    async function initProvider() {
      if (window.ethereum) {
        const ethProvider = new ethers.providers.Web3Provider(window.ethereum);
        setProvider(ethProvider);

        try {
          await window.ethereum.enable();
          const accounts = await ethProvider.listAccounts();
          setAccount(accounts[0]);

          const networkId = await ethProvider.getNetwork();
          const deployedNetwork: any = BallotContract.networks[networkId.chainId as keyof typeof BallotContract.networks];
          const contractInstance = new ethers.Contract(
            deployedNetwork.address,
            BallotContract.abi,
            ethProvider.getSigner()
          );
          setContract(contractInstance);

          // Load proposals
          const proposalCount = await contractInstance.proposalsLength();
          const loadedProposals: Proposal[] = [];
          for (let i = 0; i < proposalCount; i++) {
            const proposal = await contractInstance.proposals(i);
            loadedProposals.push({
              name: proposal.name,
              voteCount: proposal.voteCount.toNumber(),
            });
          }
          setProposals(loadedProposals);
        } catch (error) {
          console.error('Error:', error);
        }
      }
    }

    initProvider();
  }, []);

  const giveRightToVote = async () => {
    try {
      await contract?.giveRightToVote(voterAddress);
      console.log('Voting rights given to:', voterAddress);
    } catch (error) {
      console.error('Error:', error);
    }
  };

  const addProposal = async () => {
    try {
      await contract?.addProposal(proposalName);
      console.log('Proposal added:', proposalName);
      const proposalCount = await contract?.proposalsLength();
      if (proposalCount !== undefined) {
        const proposal = await contract?.proposals(proposalCount - 1);
        setProposals([
          ...proposals,
          {
            name: proposal.name,
            voteCount: proposal.voteCount.toNumber(),
          },
        ]);
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };

  const vote = async () => {
    try {
      if (selectedProposalIndex !== null) {
        await contract?.vote(selectedProposalIndex);
        console.log('Voted for proposal:', selectedProposalIndex);
        const updatedProposals = [...proposals];
        updatedProposals[selectedProposalIndex].voteCount++;
        setProposals(updatedProposals);
        setSelectedProposalIndex(null);
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };

  return (
    <div className="App">
      <h1>Ballot Contract UI</h1>
      {account && <p>Connected Account: {account}</p>}
      <h2>Give Voting Rights</h2>
      <input
        type="text"
        placeholder="Voter Address"
        value={voterAddress}
        onChange={(e) => setVoterAddress(e.target.value)}
      />
      <button onClick={giveRightToVote}>Give Rights</button>
      <h2>Add Proposal</h2>
      <input
        type="text"
        placeholder="Proposal Name"
        value={proposalName}
        onChange={(e) => setProposalName(e.target.value)}
      />
      <button onClick={addProposal}>Add Proposal</button>
      <h2>Vote for Proposal</h2>
      <select
        value={selectedProposalIndex !== null ? selectedProposalIndex : ''}
        onChange={(e) => setSelectedProposalIndex(Number(e.target.value))}
      >
        <option value="" disabled>Select a Proposal</option>
        {proposals.map((proposal, index) => (
          <option key={index} value={index}>
            {proposal.name} ({proposal.voteCount} votes)
          </option>
        ))}
      </select>
      <button onClick={vote} disabled={selectedProposalIndex === null}>
        Vote
      </button>
    </div>
  );
};

export default App;
