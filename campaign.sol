pragma solidity ^0.5.0;

/*
    Contract should be as lightweight as possible (costs more money).
    Move error handling and complex logic to upper application layer.
*/
contract Campaign {
    struct Request {
        string description;
        uint amount;
        address payable recipient;
        mapping(address=>bool) backerStands;
        bool completed;
        uint approvalsCount;
    }
    
    address public manager;
    uint public minContribution;
    mapping(address => bool) public backers;
    Request[] public requests;  
    uint public backersCount;
    
    constructor(uint _minContribution, address _manager) public {
        manager = _manager;
        minContribution = _minContribution;
    }
    
    function createRequest(string memory des, uint amount, address payable recipient) public {
        require(msg.sender == manager, "Only manager can create request");
        Request memory newRequest = Request({
           description: des,
           amount:amount,
           recipient:recipient,
           completed: false,
           approvalsCount:0
        });
        
        requests.push(newRequest);
    }
    
    function contribute() public payable {
        require(msg.value >= minContribution, "Must contribute min amount!");
        
        backers[msg.sender] = true;
        backersCount++;
    }
    
    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function approveRequest(uint requestID) public {
        // must be a backer
        require(backers[msg.sender], "You are not a backer");
        
        // must not vote before
        require(!requests[requestID].backerStands[msg.sender], "You already voted");
        
        requests[requestID].backerStands[msg.sender] = true;
        requests[requestID].approvalsCount++;
    }
    
    // FINALIZE REQUEST HOMEWORK            -- EXTRA CREDIT
    function finalizeRequest(uint requestID) public payable {
        // make sure changes are reflected in array
        Request storage request = requests[requestID];
        // must be a manager
        require(msg.sender == manager, "You must be a manager.");
        // must not be completed
        require(!request.completed, "Request cannot be completed.");
        // must have >50% approvalsCount
        require(request.approvalsCount > (backersCount / 2), "Approval must be > 50%.");
        
        // recipient and function must be payable when using transfer()
        request.recipient.transfer(request.amount);
        request.completed = true;
    }
    
    // BUILD DECENTRALIZED BANK HOMEWORK    -- EXTRA CREDIT
}