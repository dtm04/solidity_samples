pragma solidity ^0.5.0;

contract Bank {
    // note: didnt need the struct, ended up using mappings instead
    struct Account {
        address payable acctOwner;
        uint balance;
    }
    address public bankOwner;
    string public bankName;
    mapping(address=>bool) accounts;
    mapping(address=>uint) balances;
    Account[] public bankMembers;
    
    // constructor
    constructor(string memory _name, address _owner) public {
        bankOwner = _owner;
        bankName = _name;
    }

    // create new account for the sender if it doesnt exist
    function createNewAccount(uint amount) public {
        // might want to require sender == bank owner to allow only the owner to create acconts?
        require(!accounts[msg.sender], "This address already owns an account.");
        /*
        Account memory newAccount = Account({
            acctOwner: msg.sender,
            balance: msg.value
        });

        bankMembers.push(newAccount);
        */
        accounts[msg.sender] = true;
        balances[msg.sender] = amount;
    }

    // get account balance of the sender if it exists
    function getBalance() public view returns (uint) {
        require(accounts[msg.sender], "Account does not exist.");
        return balances[msg.sender];
    }

    // deposit from outside to recipient
    function deposit(address payable recipient, uint amount) public payable {
        require(accounts[recipient], "Account does not exist.");
        balances[recipient] += amount;
    }

    // transfer from sender to recipient
    function transfer(address payable recipient) public payable {
        require(accounts[recipient], "Account does not exist.");
        balances[recipient] += msg.value;
    }
}