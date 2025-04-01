// SPDX-License-Identifier: MIT

// 1️⃣ Create Event for creating the tweet, called TweetCreated
// USE parameters like id, author, content, timestamp
// 2️⃣ Emit the Event in the createTweet() function below 
// 3️⃣ Create Event for liking the tweet, called TweetLiked 
// USE parameters like liker, tweetAuthor, tweetId, newLikeCount
// 4️⃣ Emit the event in the likeTweet() function below

pragma solidity ^0.8.0;

contract Twitter {

    uint16 public MAX_TWEET_LENGTH = 280;

    struct Tweet {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
        uint256 id;
    }
    mapping(address => Tweet[] ) public tweets;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event TweetCreated (uint256 id, address author, string content, uint256 timestamp);

    event TweetLiked (address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    event TweetUnliked (address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Message to long" );

        Tweet memory newTweet = Tweet({
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0,
            id: tweets[msg.sender].length
        });

        tweets[msg.sender].push(newTweet);

        //uint256 id, address author, string content, uint256 timestamp
        emit TweetCreated (newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function getTweet( uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory ){
        return tweets[_owner];
    }

    function addLike (address author, uint256 id) external {
        require(tweets[author][id].author != owner, "Jestes wlasciwosciem, nie mozesz likowac wlasnego posta");
        require(tweets[author][id].id == id, "Nie ma takiego tweetu");
        tweets[author][id].likes++;

        //address liker, address tweetAuthor, uint256 id, uint256 newLikeCount
        emit TweetLiked (msg.sender, author, id, tweets[author][id].likes);
    }

    function removeLike (uint256 id, address author) external {
        require(tweets[author][id].id == id, "Nie ma takiego tweetu");
        require(tweets[author][id].likes > 0, "Nie mozesz usunac like");
        tweets[author][id].likes--;

        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

}