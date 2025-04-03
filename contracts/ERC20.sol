// SPDX-License-Identifier: MIT
//https://docs.openzeppelin.com/contracts/3.x/erc20
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address public owner;

    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        owner = msg.sender;
        _mint(owner, initialSupply * 10 ** decimals());
    }

    //przelew
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    //pozwolenie dla innego adresu na wykonanie przelewu
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    //przelew przez zatwierdzony adres
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 currentAllowance = allowance(sender, msg.sender);
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    //sprawdzenie salda danego użytkownika
    function balanceOf(address account) public view override returns (uint256) {
        return super.balanceOf(account);
    }

    //sprawdzenie liczby wszystkich tokenów
    function totalSupply() public view override returns (uint256) {
        return super.totalSupply();
    }

    //check amount of accepted tokeens
    function allowance(address _owner, address spender) public view override returns (uint256) {
        return super.allowance(_owner, spender);
    }
}