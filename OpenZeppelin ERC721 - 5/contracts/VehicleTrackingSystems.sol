// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
 
contract Cars is ERC721URIStorage,  Ownable {

    uint256 public CarCount;

    struct Car {
        address manufacturer;
        string name;
        string model;
        uint256 year;
        uint256 timeregistered;
        
    }
    struct ServiceCar{
        address ServiceProvider;
        string name;
        bool isapproved;
    }
    struct ServiceLog{
                address ServiceProvider;

        uint256 carId;
        uint256 timeServiced;
        string nameProvider;
        string description;
    }
     mapping(uint256 => Car) public cars;
     mapping(address => ServiceCar) public Serviceprovider;
     mapping(uint256 => ServiceLog) public logs;
    
    event CarRegistered(uint256 CarId, address indexed manufacturer, string car_name, string car_model, uint256 year, uint256 timeregisterd);
    event CarServiced(uint256 CarId, address indexed serviceprovider, uint256 timeServiced , string nameProvider, string description);
    
    constructor()
        ERC721("Car for sales", "CFS")
        Ownable(msg.sender)
    {}
    
    function registerCar(
        string memory _name,
        string memory _model,
        uint256 _year,
        string memory _tokenURI
    ) public onlyOwner {
         CarCount++;

        uint256 tokenId = CarCount;

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        cars[tokenId] = Car({
            manufacturer: msg.sender,
            name: _name,
            model: _model,
            year:_year,
            timeregistered: block.timestamp
        });
        
        emit CarRegistered(CarCount, msg.sender, _name, _model ,_year, block.timestamp);
        
    }

    function addServiceprovider(address newStakeholder, string memory _newName) public onlyOwner {
        Serviceprovider[newStakeholder] = ServiceCar({ ServiceProvider: newStakeholder , name : _newName, isapproved : true});
    }
 modifier onlyServiceProvider{
        require(Serviceprovider[msg.sender].isapproved == true , "Not approved service provider");
    _;
    }
   function logService(string memory _newDescription, uint256 id, string memory _tokenURI
) public onlyServiceProvider{
                require(id > 0 && id <= CarCount, "Car not found");
              uint256 tokenId = id;

        _setTokenURI(tokenId, _tokenURI);

        logs[id] = ServiceLog({ ServiceProvider: msg.sender, carId: id, timeServiced : block.timestamp , description : _newDescription , nameProvider: Serviceprovider[msg.sender].name});
     emit CarServiced(id, msg.sender, block.timestamp,  Serviceprovider[msg.sender].name , _newDescription ); 
   }

function getServiceDetails(uint256 carId) public view returns (address, uint256, uint256, string memory, string memory){
    
        require(carId > 0 && carId <= CarCount, "Invalid car ID");
        ServiceLog storage log= logs[carId];
        return (log.ServiceProvider, log.carId, log.timeServiced, log.nameProvider, log.description);
}
    function getCarDetails(uint256 carId) public view returns (address, string memory, string memory, uint256, uint256 , string memory) {
     
        require(carId > 0 && carId <= CarCount, "Invalid car ID");
        
        Car storage car = cars[carId];
        return ( car.manufacturer,car.name, car.model, car.year, car.timeregistered, tokenURI(carId));
    }
    }

   
