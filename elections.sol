// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

    error NotOwner();

contract elections {

    address private immutable i_owner;
    constructor(){
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        if(i_owner != msg.sender) revert NotOwner();
        _;
    }

    struct dataBase {
        string candidate;
        uint256 candidateVotes;    
    }

    dataBase[] public candidates;

    function addCandidate(string memory _addCandidate) public onlyOwner {
        candidates.push(dataBase(_addCandidate, 0));
    }

    mapping(address => bool) hasVoted;

    function vote(uint256 candidateNumber) public {
        require(candidateNumber < candidates.length);
        require(hasVoted[msg.sender] == false);

        candidates[candidateNumber].candidateVotes++;

        hasVoted[msg.sender] = true;        
    }

    function winner() public view returns (string memory) {
        require(candidates.length > 0);

        uint256 _mostVotes;
        uint256 _winner;

        for(uint256 x=0; x < candidates.length; x++) {
            if(candidates[x].candidateVotes > _mostVotes) {
                _mostVotes = candidates[x].candidateVotes;
                _winner = x;
            }
        }

        require(_mostVotes > 0);
        return candidates[_winner].candidate;
    }
}