pragma solidity ^0.6.3;

contract HelloWorld {
    string hash = "defaultHash";

   
   function setHash(string memory _hashTemp) public {
       hash = _hashTemp;
   }
   
   function getHash() public view returns (string memory) {
       return hash;
   } 
}
