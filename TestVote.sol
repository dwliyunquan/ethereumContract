pragma solidity ^0.4.18;

contract TestVote {

    struct Proposal {
        uint name;   
        uint voteCount; 
    }

    address public chairperson;

    Proposal[] public proposals;

    function TestVote(uint[] proposalNames) public {
        chairperson = msg.sender;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    

    function vote(uint proposal) public {
        proposals[proposal].voteCount += 1;
    }

    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view
            returns (uint winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}