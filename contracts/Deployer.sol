pragma solidity ^0.4.21;

import "./TokenToTokenSwap.sol";

/**Swap Deployer Contract - purpose is to save gas for deployment of Factory contract.
*It also ensures only the factory can create new contracts.
*/
contract Deployer {
    /*Variables*/
    address internal owner;
    address internal factory;
    
    /*Functions*/
    /**
     *@dev Deploys the factory contract 
     *@param _factory is the address of the factory contract
    */    
    function Deployer(address _factory) public {
        factory = _factory;
        owner = msg.sender;
    }

    /**
    *@notice The function creates a new contract
    *@dev It ensures the new contract can only be created by the factory
    *@param _party address of user creating the contract
    *@param user_contract address of userContract.sol 
    *@param _start_date contract start date
    *@return returns the address for the new contract
    */
    function newContract(address _party, address user_contract, uint _start_date) public returns (address) {
        require(msg.sender == factory);
        address new_contract = new TokenToTokenSwap(factory, _party, user_contract, _start_date);
        return new_contract;
    }

    /**
     *@dev Set variables if the owner is the factory contract
     *@param _factory address
     *@param _owner address
    */
    function setVars(address _factory, address _owner) public {
        require (msg.sender == owner);
        factory = _factory;
        owner = _owner;
    }
}
