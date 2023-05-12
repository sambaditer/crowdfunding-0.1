// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address payable private _creator;
    uint256 private _goal;
    uint256 private _deadline;
    mapping(address => uint256) private _contributions;
    uint256 private _totalContributions;

    constructor(uint256 goal_, uint256 durationDays_) {
        _creator = payable(msg.sender);
        _goal = goal_ * 1 ether; // Convert to wei
        _deadline = block.timestamp + (durationDays_ * 1 days);
    }

    function contribute() public payable {
        require(block.timestamp <= _deadline, "Crowdfunding: deadline has passed");
        _contributions[msg.sender] += msg.value;
        _totalContributions += msg.value;
    }

    function withdraw() public {
        require(block.timestamp > _deadline, "Crowdfunding: deadline has not passed");
        require(_totalContributions >= _goal, "Crowdfunding: goal not reached");
        require(msg.sender == _creator, "Crowdfunding: only creator can withdraw");
        _creator.transfer(address(this).balance);
    }

    function getContributions(address contributor) public view returns (uint256) {
        return _contributions[contributor];
    }

    function getTotalContributions() public view returns (uint256) {
        return _totalContributions;
    }

    function getGoal() public view returns (uint256) {
        return _goal;
    }

    function getDeadline() public view returns (uint256) {
        return _deadline;
    }
}
