// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// total supply is the amount of token in circulation within a given time frame.
// Initial supply refers to the number of tokens available at the token's launch.
// Total supply is the sum of tokens in circulation and those not yet distributed.
// Maximum supply is the upper limit of tokens that can ever exist for the token.
contract CHTIX {
    string _name;
    string _sym;
    uint8 _decimals;
    uint256 _totalSupply;
    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances; // owner => spender => amount
    event _Transfer(address indexed _from, address indexed _to, uint256 _value);
    event _Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event _Mint(address indexed _to, uint256 _value);
    event _Burn(address indexed _from, uint256 _value);

    constructor(string memory name_, string memory sym_, uint8 decimals_, uint256 totalSupply_) {
        _name = name_;
        _sym = sym_;
        _decimals = decimals_;
        _totalSupply = totalSupply_;
    }
    function name() public view returns (string memory) {
        return _name;
    }
    function sym() public view returns (string memory) {
        return _sym;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address owner_) public view returns (uint256 balance_) {
        balance_ = _balances[owner_];
    }
    /**
     * Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The function SHOULD throw if the message caller’s * account balance does not have enough tokens to spend.
     * Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
     */
    function transfer(address _to, uint256 _value) public returns (bool success_) {
        // do not allow transfer to 0x0 or the token contract itself
        require((_to != address(0)) && (_to != address(this)), 'Cannot transfer to address zero or self');
        // do not allow transfer if the balance is insufficient
        require(_balances[msg.sender] >= _value, 'Insufficient funds');
        // do not transfer if the amount is 0 or less than 0
        require(_value > 0, 'invalid amount');
        // do not allow transfer if the amount is greater than the total supply
        require(_value <= _totalSupply, 'Cannot transfer more than the total supply');
        // subtract from the sender
        _balances[msg.sender] -= _value;
        // add the same to the recipient
        _balances[_to] += _value;
        // fire a transfer event
        emit _Transfer(msg.sender, _to, _value);
        // return a boolean
        success_ = true;
    }
    /**
     * allowance
     * Returns the amount which _spender is still allowed to withdraw from _owner.
     */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining_) {
        remaining_ = _allowances[_owner][_spender];
    }
    /**
     *  transferFrom
     *  Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
     *  The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. This can be used for *  example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies. The function SHOULD throw *  *  unless the _from account has deliberately authorized the sender of the message via some mechanism.
     *  Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success_) {
        // do not allow transfer to 0x0 or the token contract itself
        require((_to != address(0)) && (_to != address(this)), 'Cannot transfer to address zero or self');
        // do not allow transfer if the balance is insufficient
        require(_balances[_from] >= _value, 'Insufficient funds');
        // do not allow transfer if the allowance is insufficient
        require(allowance(_from, _to) >= _value, 'Insufficient allowance');
        // do not transfer if the amount is 0 or less than 0
        require(_value > 0, 'invalid amount');
        // do not allow transfer if the amount is greater than the total supply
        require(_value <= _totalSupply, 'Cannot transfer more than the total supply');
        // subtract from the sender
        _balances[_from] -= _value;
        // add the same to the recipient
        _balances[_to] += _value;
        // subtract from the allowance
        _allowances[_from][msg.sender] -= _value;
        // fire a transfer event
        emit _Transfer(_from, _to, _value);
        // return a boolean
        success_ = true;
    }
    /**
     * approve
     * Allows _spender to withdraw from your account multiple times, up to the _value amount. If this function is called again it overwrites * the current allowance with _value.
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // do not allow approval to 0x0 or the token contract itself
        require((_spender != address(0)) && (_spender != address(this)), 'Cannot approve to address zero or self');
        // do not allow approval if the amount is 0 or less than 0
        require(_value > 0, 'invalid amount');
        // do not allow approval if the amount is greater than the total supply
        require(_value <= _totalSupply, 'Cannot approve more than the total supply');
        // set the allowance
        _allowances[msg.sender][_spender] = _value;
        // fire an approval event
        emit _Approval(msg.sender, _spender, _value);
        // return a boolean
        success = true;
    }
    /**
     * increaseAllowance
     * Atomically increases the allowance granted to _spender by the caller.
     */
    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool success) {
        // do not allow approval to 0x0 or the token contract itself
        require((_spender != address(0)) && (_spender != address(this)), 'Cannot approve to address zero or self');
        // do not allow approval if the amount is 0 or less than 0
        require(_addedValue > 0, 'invalid amount');
        // do not allow approval if the amount is greater than the total supply
        require(_addedValue <= _totalSupply, 'Cannot approve more than the total supply');
        // set the allowance
        _allowances[msg.sender][_spender] += _addedValue;
        // fire an approval event
        emit _Approval(msg.sender, _spender, _allowances[msg.sender][_spender]);
        // return a boolean
        success = true;
    }
    /**
     * decreaseAllowance
     * Atomically decreases the allowance granted to _spender by the caller.
     */
    function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool success) {
        // do not allow approval to 0x0 or the token contract itself
        require((_spender != address(0)) && (_spender != address(this)), 'Cannot approve to address zero or self');
        // do not allow approval if the amount is 0 or less than 0
        require(_subtractedValue > 0, 'invalid amount');
        // do not allow approval if the amount is greater than the total supply
        require(_subtractedValue <= _totalSupply, 'Cannot approve more than the total supply');
        // set the allowance
        _allowances[msg.sender][_spender] -= _subtractedValue;
        // fire an approval event
        emit _Approval(msg.sender, _spender, _allowances[msg.sender][_spender]);
        // return a boolean
        success = true;
    }
    /**
     * mint
     * Creates _amount tokens and assigns them to address _to, increasing the total supply.
     * The contract SHOULD fire the Transfer event with _from set to 0x0 when tokens are created.
     * make it payable
     * allow people to mint 1 token for 5 ether
     */
    function mint(address _to, uint256 _amount) external payable returns (bool success) {
        // do not allow minting to 0x0 or the token contract itself
        require((_to != address(0)) && (_to != address(this)), 'Cannot mint to address zero or self');
        // do not allow minting if the amount is 0 or less than 0
        require(_amount > 0, 'invalid amount');
        // do not allow minting if the amount is greater than the total supply
        require(_amount <= _totalSupply, 'Cannot mint more than the total supply');
        // do not allow minting if the amount is less than 5 ether
        // calculate the amount of ether required
        uint256 _etherRequired = _amount * 5 * 10 ** 18;
        // do not allow minting if the amount of ether sent is less than the amount of ether required
        require(msg.value >= _etherRequired, 'Insufficient ether sent');
        // add the amount to the recipient
        _balances[_to] += _amount;
        // add the amount to the total supply
        _totalSupply += _amount;
        // fire a transfer event
        emit _Mint(_to, _amount);
        // return a boolean
        success = true;
    }
    /**
     * owner
     * Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return payable(msg.sender);
    }
    /**
     * burn
     * Destroys _amount tokens from address _from, reducing the total supply.
     * only burn 90% and send 10% to another chosen address
     */
    function burn(address _from, uint256 _amount, address _to) external returns (bool success) {
        // do not allow burning from 0x0 or the token contract itself
        require((_from != address(0)) && (_from != address(this)), 'Cannot burn from address zero or self');
        // do not allow burning if the balance is insufficient
        require(_balances[_from] >= _amount, 'Insufficient funds');
        // do not allow burning if the amount is 0 or less than 0
        require(_amount > 0, 'invalid amount');
        // do not allow burning if the amount is greater than the total supply
        require(_amount <= _totalSupply, 'Cannot burn more than the total supply');
        // subtract from the sender
        _balances[_from] -= _amount;
        // get 10% of the amount
        uint256 _tenPercent = _amount / 10;
        // get 90% of the amount
        uint256 _ninetyPercent = _amount - _tenPercent;
        // burn 90% of the amount
        _totalSupply -= _ninetyPercent;
        // send 10% of the amount to the chosen address
        _balances[_to] += _tenPercent;
        // fire a transfer event
        emit _Burn(_from, _amount);
        // return a boolean
        success = true;
    }
    /**
     * withdraw
     * withdraw ether from the contract
     */
    function withdraw() external returns (bool success) {
        // do not allow withdrawal if the sender is not the owner
        require(msg.sender == owner(), 'Only the owner can withdraw');
        // transfer the ether to the contract owner
        payable(owner()).transfer(address(this).balance);
        // return a boolean
        success = true;
    }
}