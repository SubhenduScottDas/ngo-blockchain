// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonation {

    struct Cause {
        uint id;
        string name;
        string description;
        address payable charity;
        uint goalAmount;
        uint fundsRaised;
        bool isOpen;
    }

    mapping(uint => Cause) public causes;
    mapping(address => uint) public donations;
    uint public causeCount;

    event CauseCreated(uint causeId, string name, address charity, uint goalAmount);
    event DonationReceived(uint causeId, address donor, uint amount);
    event CauseClosed(uint causeId, string name, address charity);

    // Create a new cause
    function createCause(string memory _name, string memory _description, uint _goalAmount) public {
        require(_goalAmount > 0, "Goal amount must be greater than 0");

        causeCount++;
        causes[causeCount] = Cause(causeCount, _name, _description, payable(msg.sender), _goalAmount, 0, true);

        emit CauseCreated(causeCount, _name, msg.sender, _goalAmount);
    }

    // Donate to a cause
    function donate(uint _causeId) public payable {
        Cause storage cause = causes[_causeId];
        require(cause.isOpen, "Cause is closed");
        require(msg.value > 0, "Donation must be greater than 0");

        cause.fundsRaised += msg.value;
        donations[msg.sender] += msg.value;

        emit DonationReceived(_causeId, msg.sender, msg.value);
    }

    // Update an existing cause
    function updateCause(uint _causeId, string memory _name, string memory _description, uint _goalAmount) public {
        Cause storage cause = causes[_causeId];
        require(msg.sender == cause.charity, "Only the charity can update this cause");

        cause.name = _name;
        cause.description = _description;
        cause.goalAmount = _goalAmount;
    }

    // Close a cause
    function closeCause(uint _causeId) public {
        Cause storage cause = causes[_causeId];
        require(msg.sender == cause.charity, "Only the charity can close this cause");

        cause.isOpen = false;

        emit CauseClosed(_causeId, cause.name, cause.charity);
    }

    // List all open causes
    function listCauses() public view returns (Cause[] memory) {
        Cause[] memory openCauses = new Cause[](causeCount);
        uint counter = 0;

        for (uint i = 1; i <= causeCount; i++) {
            if (causes[i].isOpen) {
                openCauses[counter] = causes[i];
                counter++;
            }
        }

        // Resize the array to the correct length
        bytes memory encoded = abi.encode(openCauses);
        assembly {
            mstore(add(encoded, 0x20), counter)
        }

        return openCauses;
    }

    // New Function: Get a cause by ID
    function getCauseById(uint _causeId) public view returns (
        uint id,
        string memory name,
        string memory description,
        address charity,
        uint goalAmount,
        uint fundsRaised,
        bool isOpen
    ) {
        Cause storage cause = causes[_causeId];
        return (
            cause.id,
            cause.name,
            cause.description,
            cause.charity,
            cause.goalAmount,
            cause.fundsRaised,
            cause.isOpen
        );
    }
}
