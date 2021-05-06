// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

/**
 * @title SmartWallet
 * @dev Store & retrieve value in a variable
 */
contract SmartWallet {

    mapping(address => uint256) private _balances;

    /**
     * @dev Return value 
     * @return balance of 'account'
     */
    function balanceOf(address account) public view returns (uint256){
        return _balances[account];
    }
    
    /**
     * @dev Store value in variable
     */
    function deposit() public payable {
        _balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) public {
        require(amount < _balances[msg.sender], "SmartWallet (withdraw): insufficient fund");
        _balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
    
    /**
     * msg.sender veut envoyer des eth à account
     */
    function transfer(address account, uint256 amount) public {        
    }
    
    function total() public view returns (uint256) {
        return address(this).balance;
    }
    
    //receive();
    //payable fallback();
}
