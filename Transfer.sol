pragma solidity ^0.4.18;

contract Token {


 mapping (address => uint) balances;


 event Issue(address account, uint amount);

 event Transfer(address fromaddress, address to,uint amount);


 function Token() {


 }


 function issue(address account, uint amount) {
     balances[account] += amount;

}


 function transfer(address fromaddress,address to, uint amount){

 if (balances[fromaddress] < amount)
    throw;
 balances[fromaddress] -= amount;
 balances[to] += amount;
 Transfer(fromaddress, to, amount);
 

 }

 function getBalance(address account)constant returns (uint) {

          return balances[account];
}


}