// SPDX-License-Identifier: MIT

// 2️⃣ Add a getProfile() function to the interface
// 3️⃣ Initialize the IProfile in the constructor
// HINT: don't forget to include the _profileContract address as a input 
// 4️⃣ Create a modifier called onlyRegistered that require the msg.sender to have a profile
// HINT: use the getProfile() to get the user
// HINT: check if displayName.length > 0 to make sure the user exists
// 5️⃣ ADD the onlyRegistered modifier to createTweet, likeTweet, and unlikeTweet function

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

interface IProfile {
    struct UserProfile {
        string displayName;
        string bio;
    }
    function getProfile(address _user) external view returns (UserProfile memory);
}

contract Twitter is Ownable {

    uint16 public MAX_TWEET_LENGTH = 280;

    // Dodanie zmiennej profileContract
    IProfile public profileContract;

    struct Tweet {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
        uint256 id;
    }
    mapping(address => Tweet[]) public tweets;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event TweetUnliked(address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    // Modyfikator sprawdzający czy użytkownik jest zarejestrowany
    modifier onlyRegistered() {
        IProfile.UserProfile memory userProfileTemp = profileContract.getProfile(msg.sender);
        require(bytes(userProfileTemp.displayName).length > 0, "User not registered");
        _;
    }

    // Konstruktor inicjalizujący profileContract
    constructor(address _profileContract) Ownable(msg.sender) {
        profileContract = IProfile(_profileContract);
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public onlyRegistered {
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Message too long");

        Tweet memory newTweet = Tweet({
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0,
            id: tweets[msg.sender].length
        });

        tweets[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function getTweet(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }

    function addLike(address author, uint256 id) external onlyRegistered {
        require(tweets[author][id].id == id, "Tweet not found");
        tweets[author][id].likes++;

        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function removeLike(uint256 id, address author) external onlyRegistered {
        require(tweets[author][id].id == id, "Tweet not found");
        require(tweets[author][id].likes > 0, "Cannot remove like");
        tweets[author][id].likes--;

        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    uint256 totalLikes;
    function getTotalLikes(address _author) external returns(uint) {
        totalLikes = 0; // Reset licznika przed sumowaniem
        for(uint i = 0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }
        return totalLikes;
    }
}
