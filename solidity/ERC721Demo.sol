pragma solidity ^0.5.8;

contract Erc721Demo {
    
    mapping(uint256 => address) private _tokenOwener;
    mapping(uint256 => address) private _tokenApprovals;
    
    event Transfer(address indexed from, address indexed to, uint256 tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    
    modifier ownToken(address from, uint256 tokenId) {
        require(_tokenOwener[tokenId] == from, 'tokenId do not belongs to given address');
        _;
    }
    
    function owenerOf(uint256 tokenId) external view returns(address owner) {
        owner = _tokenOwener[tokenId];
        require(owner != address(0), 'Owner is address 0');
    }
    
    function mint(uint256 tokenId) public payable {
        require(_tokenOwener[tokenId] == address(0), 'Token already taken');
        require(msg.value >= 1 ether, 'Less than 1 ether is not enough');
        require(msg.value < 10 ether, 'Please send less than 10 ether');
        _tokenOwener[tokenId] = msg.sender;
    }
    
    function approve(address to, uint256 tokenId) public {
        require(to != address(0), 'address is invalid');
        require(_tokenOwener[tokenId] == msg.sender, 'address do not match with message sender');
        _tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }
    
    function transferFrom(address from, address to, uint256 tokenId) external ownToken(from, tokenId) {
        require(_tokenOwener[tokenId] == from, 'Owner of tokenId validation failed');
        require(to != address(0), 'receiptant address is not a valid address');
        bool isOwner = (msg.sender == from);
        bool isApproved = (msg.sender == _tokenApprovals[tokenId]);
        require(isApproved || isOwner, 'authentication failed');
        _tokenOwener[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
}