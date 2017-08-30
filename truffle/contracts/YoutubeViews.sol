pragma solidity ^0.4.0;

import "./oraclizeAPI.sol";

contract YoutubeViews is usingOraclize {

	event ChangeCount(uint _value);

    uint public viewsCount;

    function YoutubeViews() payable {
        OAR = OraclizeAddrResolverI(0x6f485c8bf6fc43ea212e93bbf8ce046c7f1cb475);
        update(0);
    }

    function __callback(bytes32 myid, string result) {
        //if (msg.sender != oraclize_cbAddress()) throw;
        viewsCount = parseInt(result, 0);
        ChangeCount(viewsCount);
        // do something with viewsCount

        //update(60); // update viewsCount every 1 minutes
    }

    function update(uint delay) payable {
        oraclize_query(delay, 'URL', 'html(https://www.youtube.com/watch?v=9bZkp7q19f0).xpath(//*[contains(@class, "watch-view-count")]/text())');
    }

}