//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

//import ERC1155 token contract from Openzepplin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract NFTContract is ERC1155, Ownable {

    uint256 public constant ARTWORK = 1;
    uint256 public constant PHOTO = 2;
    uint256 public constant PIC = 3;

    uint256[] supplies = [70,20,10];
    uint256[] minted = [0,0,0];
    uint256[] rates = [0.01 ether, 0.02 ether, 0.03 ether];

    constructor() ERC1155("https://gateway.pinata.cloud/ipfs/Qmf7Pb7DAuXP4ZJjD9pgVd7oDdTY1V7Sviq9iyn2LWz5bN/{id}.json") {} // Image files in constructor are tickets in envelope, so buyers can not immediatly see what ticket they got 

    function mint(address account, uint256 id, uint256 amount) public payable {

        require(id <= supplies.length, "Token doesnt exist");
        require(id > 0, "Token doesnt exist");

        require(minted[id] + amount <= supplies[id], "not enough supply");
        require(msg.value >= amount * rates[id], "Not enough ether");
        _mint(msg.sender, id, amount, "");
        _uri[id] == uri("https://gateway.pinata.cloud/ipfs/Qmf7Pb7DAuXP4ZJjD9pgVd7oDdTY1V7Sviq9iyn2LWz5bN/" + string(id) + ".json") // Reveal NFT after mint -> uri of each NFT gets revealed ticket image
        minted[id] += amount;
    }

    function burn(address account, uint256 id, uint256 amount) public{
        require(msg.sender == account);
        _burn(account, id, amount);

    }
}
