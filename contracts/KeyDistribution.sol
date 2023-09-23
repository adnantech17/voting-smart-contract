// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract KeyDistribution {

    uint256 private constant key_count = 5;
    uint256[key_count] private th_keys;
    uint256[] private taken;
    uint256 private iterator = 0 ;
    constructor() {
        // Initialize key generation parameters (simplified)
        for(uint256 i = 0 ; i < key_count;i++){
            th_keys[i] = (i+1)*512345;
        }
    }
    function generateRandomNumber(uint256 min, uint256 max) internal view returns (uint256) {
        require(min <= max, "Invalid range");
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, blockhash(block.number - 1))));
        return (randomNumber % (max - min + 1)) + min;
    }
    function getKey() public returns (uint256){
        if(iterator>=key_count)
            return 0;
        iterator++;
        return th_keys[iterator - 1];
        
    }
   
}
