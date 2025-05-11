// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VehicleTrackingSystem {
    address public owner;
    uint256 public CarCount;

    // Define the Car struct
    struct Car {
        address manufacturer;
        string car_name;
        string car_model;
        string origin;
        uint256 price;
        uint256 timestamp;
    }

    // Mapping from car ID to car data
    mapping(uint256 => Car) public cars;

    // Declare the event
    event CarRegistered(uint256 CarId, address indexed manufacturer, string car_name, string car_model, string origin, uint256 price, uint256 timestamp);

    // Modifier to check if the caller is the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor() {
        owner = msg.sender; // Set the contract owner to the address that deploys the contract
    }

    // Function to register a car
    function RegisterCar( string memory _car_name, string memory _car_model, string memory _origin, uint256 _price) public onlyOwner {
        // Increment CarCount to generate a unique car ID
        CarCount++;

        // Create a new car and store it in the cars mapping
        cars[CarCount] = Car(msg.sender, _car_name, _car_model, _origin, _price, block.timestamp);

        // Emit an event to signify the creation of a new car
        emit CarRegistered(CarCount, msg.sender, _car_name, _car_model, _origin, _price, block.timestamp);
    }

    // Function to retrieve a specific car by ID
    function getCarDetails(uint256 _productId) public view returns (string memory _car_name, address manufacturer, string memory car_model, uint256 price, uint256) {
        // Check if the provided product ID is valid
        require(_productId > 0 && _productId <= CarCount, "Invalid product ID");
        
        // Retrieve and return the details of the specified product
        Car storage product = cars[_productId];
        return (product.car_name, product.manufacturer, product.car_model, product.price, product.timestamp);
    }
}
