// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// 1️⃣  Use require to limit the length of the tweet to be only 280 characters
// HINT: use bytes to length of tweet

contract Twitter {

    uint8 constant MAX_TWWET_LENGTH = 255;

    struct Tweet {
        address author;
        string content;
        uint256 timestamp;
        uint likes;
    }

    mapping(address => Tweet[]) public tweets;

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWWET_LENGTH, "Message to long");

        Tweet memory newTweet = Tweet({
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function getTweet( uint _i) public view  returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
    
}