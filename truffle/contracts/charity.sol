// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityChain {
    struct Charity {
        string name;
        string description;
        address wallet;
    }

    struct User {
        string name;
        string description;
        address wallet;
    }

    struct Transaction {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
    }

    Charity[] public charities;
    User[] public users;
    Transaction[] public transactions;

    address public owner;
    uint256 public difficulty = 2;

    event CharityAdded(uint256 charityId, string name, address wallet);
    event UserAdded(uint256 userId, string name, address wallet);
    event TransactionCreated(address from, address to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function addCharity(string memory name, string memory description, address wallet) public onlyOwner {
        charities.push(Charity(name, description, wallet));
        emit CharityAdded(charities.length - 1, name, wallet);
    }

    function addUser(string memory name, string memory description, address wallet) public {
        users.push(User(name, description, wallet));
        emit UserAdded(users.length - 1, name, wallet);
    }

    function createTransaction(address to, uint256 amount) public {
        transactions.push(Transaction(msg.sender, to, amount, block.timestamp));
        emit TransactionCreated(msg.sender, to, amount);
    }

    function mineBlock(uint256 nonce) public onlyOwner returns (bytes32) {
        bytes32 hash = keccak256(abi.encodePacked(transactions.length, nonce));
        require(uint256(hash) < 2**(256 - difficulty), "Proof of Work failed");

        // Reset transactions
        delete transactions;
        
        return hash;
    }
}
