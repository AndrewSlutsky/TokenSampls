pragma solidity ^0.6.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

//My implementation of IERC20

contract MyERC20 is IERC20 {
    //event that emitted when value is approved by the owner to spend by spender
    event Approval(address indexed owner, address indexed spender, uint256 value);
    // event that emitted when value s sent from the 'from' address to the 'to' address
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    //mapping type that connect token amount to the address which have those tokens
    mapping(address => uint256) balances;
    //mapping type that connect one address who gave a permission for another to use amount of tokens
    mapping(address => mapping(address => uint256)) allowed;
    
    //total amount of tokens
    uint256 totalSupply_;
    
    //creation of the token and the initialization of total amount of tokens which was given to the main owner
    constructor(uint256 total) public{
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
    }
    
    //simple getter
    function totalSupply() public override view returns(uint256){
        return totalSupply_;
    }
    
    //return the amount of tokens which 'account' has
    function balanceOf(address account) public override view returns(uint256){
        return balances[account];
    }
    
    //return the amount of tokens which 'owner' allowed to use to the 'spender'
    function allowance(address owner, address spender) public override view returns (uint256){
        return allowed[owner][spender];
    }
    
    //Moves the amount of tokens from msg.sender to recipient with checking amount of tokens which sender has
    // emit the Transfer event and return true if transfer was possible.
    function transfer(address recipient, uint256 amount) public override returns (bool){
        require(amount <=balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
    //The msg.sender give allowance to the spender to spend the amount of tokens
    //emit the Approval event and return true if allowance was successfuly set
    function approve(address spender, uint256 amount) public override returns (bool){
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool){
        require(amount <=allowed[sender][msg.sender]);
        require(amount <=balances[sender]);
        balances[sender] = balances[sender] - amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}