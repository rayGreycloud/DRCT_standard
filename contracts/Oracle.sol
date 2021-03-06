pragma solidity ^0.4.23;

import "oraclize-api/usingOraclize.sol";

/**
*The Oracle contract provides the reference prices for the contracts.  Currently the Oracle is 
*updated by an off chain calculation by DDA.  Methodology can be found at 
*www.github.com/DecentralizedDerivatives/Oracles
*/

contract Oracle is usingOraclize{
    /*Variables*/
    //Private queryId for Oraclize callback
    bytes32 private queryID;
    string public API;


    //Mapping of documents stored in the oracle
    mapping(uint => uint) public oracle_values;
    mapping(uint => bool) public queried;

    /*Events*/
    event DocumentStored(uint _key, uint _value);
    event newOraclizeQuery(string description);

    /*Functions*/
    /*
    *@dev - Constructor, sets public api string
    */
     constructor() public{
        API = "https://api.gdax.com/products/BTC-USD/ticker).price";
    }

    /*
    *@dev RetrieveData - Returns stored value by given key
    *@param "_date": Daily unix timestamp of key storing value (GMT 00:00:00)
    */
    function retrieveData(uint _date) public constant returns (uint) {
        uint value = oracle_values[_date];
        return value;
    }

    /**
    *@dev PushData - Sends an Oraclize query for entered API
    */
    function pushData() public payable{
        uint _key = now - (now % 86400);
        require(queried[_key] == false);
        if (oraclize_getPrice("URL") > address(this).balance) {
            emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            emit newOraclizeQuery("Oraclize queries sent");
            queryID = oraclize_query("URL", "json(https://api.gdax.com/products/BTC-USD/ticker).price");
            queried[_key] = true;
        }
    }

    /**
    *@dev Used by Oraclize to return value of PushData API call
    *@param _oraclizeID unique oraclize identifier of call
    *@param _result Result of API call in string format
    */
    function __callback(bytes32 _oraclizeID, string _result) public {
        require(msg.sender == oraclize_cbAddress() && _oraclizeID == queryID);
        uint _value = parseInt(_result,3);
        uint _key = now - (now % 86400);
        oracle_values[_key] = _value;
        emit DocumentStored(_key, _value);
    }

    /**
    *@dev Allows the contract to be funded in order to pay for oraclize calls
    */
    function fund() public payable {
      
    }

    /**
    *@dev Determine if the Oracle was queried
    *@param _date Daily unix timestamp of key storing value (GMT 00:00:00)
    *@return Returns true or false based upon whether an API query has been 
    *initialized (or completed) for given date
    */
    function getQuery(uint _date) public view returns(bool){
        return queried[_date];
    }
}