// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/**
 * @title SmartWallet
 * @dev Store & retrieve value in a variable
 */
contract SmartWallet {

    mapping(address => uint256) private _balances;
    address private _owner;
    uint8 private _percentage;
    uint256 private _gain;

    constructor(address owner_, uint8 percentage_) {
        require(percentage_ < 100, "SmartWallet (constructor): percentage too high");
        _owner = owner_;
        _percentage = percentage_;
    }

    /**
     * @dev Return value 
     * @return balance of 'account'
     */
    function balanceOf(address account) public view returns (uint256){
        return _balances[account];
    }
    
    /**
     * @dev Store msg.value in _balances
     */
    function deposit() public payable {
        _balances[msg.sender] += msg.value;
    }
    
    // Exercice 1:
    // Implementer une fonction withdrawAmount pour permettre à un utilisateur
    // de récupérer un certain amount de ses fonds
    function withdraw(uint256 amount) public {
        require(amount < _balances[msg.sender], "SmartWallet (withdraw): insufficient fund");
        uint256 fee = (amount * _percentage) / 100;
        _balances[msg.sender] -= fee;
        amount -= fee;
        _balances[msg.sender] -= amount;
        _balances[_owner] += fee;
        _gain += fee;
        payable(msg.sender).transfer(amount);
    }

    function withdrawAll() public {
        require(_balances[msg.sender] > 0, "SmartWallet: can not withdraw 0 ether");
        uint256 amount = _balances[msg.sender];
        uint256 fee = (amount * _percentage) / 100;
        _balances[msg.sender] -= fee;
        amount -= fee;
        _balances[_owner] += fee;
        _gain += fee;
        _balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function withdrawGain() public {
        require(msg.sender == _owner, "Only owner can withdraw gain");
        payable(msg.sender).transfer(_balances[msg.sender]);
    }
    
    // Exercice 2:
    // Implementer une fonction transfer pour permettre à un utilisateur d'envoyer
    // des fonds à un autre utilisateur de notre SmartWallet
    // ATTENTION on effectue pas un vrai transfer d'ETHER, 
    // un transfer n'est qu'une ecriture comptable dans un registre
    /**
     * msg.sender veut envoyer des eth à account
     */
    function transfer(address account, uint256 amount) public {
        require(amount < _balances[msg.sender], "SmartWallet (transfer): insufficient fund");
        _balances[msg.sender] -= amount;
        _balances[account] += amount;
    }
    
    function total() public view returns (uint256) {
        return address(this).balance;
    }

    function percent() public view returns (uint8) {
        return _percentage;
    }

    // Exercice 4
    function setPercentage(uint8 percentage_) public {
        require(msg.sender == _owner, "Only owner can set percentage fee");
        _percentage = percentage_;
    }

    // Exercice 5
    function gain() public view returns (uint256) {
        return _gain;
    }
    
    //receive();
    //payable fallback();
}
