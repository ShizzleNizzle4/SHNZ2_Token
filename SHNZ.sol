pragma solidity ^0.4.11;

import "./Ownable.sol";
import "./SafeMath.sol";
import "./ERC20.sol";

contract SHNZ is ERC20, Ownable {
    
    using SafeMath for uint256;
    
    uint256 private tokensSold;
    
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowances;
  
    event TokensIssued(address from, address to, uint256 amount);

    function SHNZ() public {
        totalSupply = 1000000000000000000;
        decimals = 8;
        name = "ShizzleNizzle";
        symbol = "SHNZ";
        balances[this] = totalSupply;
    }

    function balanceOf(address _addr) public constant returns (uint256) {
        return balances[_addr];
    }

    function transfer(address _to, uint256 _amount) public returns (bool) {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Transfer(msg.sender, _to, _amount);
        return true;
    }
    
    function approve(address _spender, uint256 _amount) public returns (bool) {
        allowances[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }
    
    function allowance(address _owner, address _spender) public constant returns (uint256) {
        return allowances[_owner][_spender];
    }
    
    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
        require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
        allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
        balances[_from] = balances[_from].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Transfer(_from, _to, _amount);
        return true;
    }
    
    function issueTokens(address _to, uint256 _amount) public onlyOwner {
        require(_to != 0x0 && _amount > 0);
        if(balances[this] <= _amount) {
            balances[_to] = balances[_to].add(balances[this]);
            Transfer(0x0, _to, balances[this]);
            balances[this] = 0;
        } else {
            balances[this] = balances[this].sub(_amount);
            balances[_to] = balances[_to].add(_amount);
            Transfer(0x0, _to, _amount);
        }
    }

    function getTotalSupply() public constant returns (uint256) {
        return totalSupply;
    }
}
