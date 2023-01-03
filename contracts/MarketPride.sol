// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MarketPride {
    struct Product {
        string name;
        string image;
        string category;
        string description;
        uint256 price;
        address seller;
        uint256 amountCollected;
    }

    struct Account {
        string userName;
        address owner;
    }

    uint256 storeLength;
    uint256 productCounter;
    Product[] products;
    Account[] accounts;
   
    mapping(uint256 => Product) product;
    mapping(address => Account) account;

    function checkUserExists(address pubkey) public view returns (bool) {
        return bytes(account[pubkey].userName).length > 0;
    }

    modifier CheckIfUserExist() {
        require(checkUserExists(msg.sender) == true, "user Already exist");
        _;
    }

    function createAnAccount(string memory _name, address _owner) external {
        require(checkUserExists(msg.sender) == false, "user Already exist");
        Account storage user = account[_owner];
        user.userName = _name;
        user.owner = msg.sender;
        accounts.push(user);
    }

    function listAProducts(
        uint256 _id,
        string memory _name,
        string memory _image,
        string memory _category,
        string memory _description,
        uint256 _price,
        address _seller
    ) external CheckIfUserExist {
        Product storage listing = product[_id];
        listing.name = _name;
        listing.image = _image;
        listing.category = _category;
        listing.description = _description;
        listing.price = _price;
        listing.seller = _seller;
        product[productCounter] = listing;
        productCounter++;
        products.push(listing);
    }

    function payForProduct(uint256 _id) public payable {
       uint256  amount = msg.value;
        Product storage listing = product[_id];
        require(
            listing.seller != msg.sender,
            "owner of products cant purchase own products"
        );
        (bool sent, ) = payable(listing.seller).call{value: amount}("");
        if(sent){
            listing.amountCollected = listing.amountCollected + amount;
        }
        require(sent, "Failed to send Ether");
    }

    //get every product
    function getAllProduct() public view returns (Product[] memory) {
        return products;
    }

    //get every account
    function getAllAccount() public view returns (Account[] memory) {
        return accounts;
    }
}
