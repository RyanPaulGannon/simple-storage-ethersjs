// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7; // Upwards of 0.8.7

contract SimpleStorage {
    uint256 favoriteNumber;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
        // favoriteNumber = favoriteNumber + 1;
    }

    // view, pure do not spend gas. 'View' purely reads from the contract. Cannot update the blockchian. Pure functions
    // don't allow you to read from the blockchain

    // Returns function is what is going to be returned

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;

    // function addPerson(string memory _name, uint256 _favoriteNumber) public {
    //     People memory newPerson = People({
    //         favoriteNumber: _favoriteNumber,
    //         name: _name
    //     });
    //     people.push(newPerson);
    // }

    mapping(string => uint256) public toFavoriteNumber;

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        toFavoriteNumber[_name] = _favoriteNumber;
    }
}

// 0xd9145CCE52D386f254917e481eB44e9943F39138
