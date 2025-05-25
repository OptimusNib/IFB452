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

// logs insurance claims and accident history
contract InsuranceRecord {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    
    // insurance incident or claim
    struct Incident {
        string summary; //description
        string insurer; //company name
        uint256 date; 
    }

    //map vehicle tokenId to list of incidents
    mapping(uint256 => Incident[]) private incidentHistory;

    //map storing approved insurers that can write
    mapping(address => bool) public approvedInsurers;

    //restricts functions to approved contract owners
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner");
        _;
    }

    //restricts functions to approved contract owners
    modifier onlyApprovedInsurer() {
        require(approvedInsurers[msg.sender], "Not an approved insurer");
        _;
    }

    // add approved contract owner
    function addApprovedInsurer(address insurer) public onlyOwner {
        approvedInsurers[insurer] = true;
    }

    //remove contract owner
    function removeApprovedInsurer(address insurer) public onlyOwner {
        approvedInsurers[insurer] = false;
    }

    //log incident
    function logIncident(uint256 tokenId, string memory summary, string memory insurer) public onlyApprovedInsurer {
        incidentHistory[tokenId].push(Incident(summary, insurer, block.timestamp));
    }

    // retrieve incidident log
    function getIncidents(uint256 tokenId) public view returns (Incident[] memory) {
        return incidentHistory[tokenId];
    }
}


contract Verification {
    //other contract references
    //VehicleRegistry public vehicleRegistry; not sure where vehicle info is stored
    Cars public serviceLog;
    InsuranceRecord public insuranceRecord;

    constructor(
        //VehicleRegistry _vehicleRegistry,
        Cars _serviceLog,
        InsuranceRecord _insuranceRecord
    ) {
        //vehicleRegistry = _vehicleRegistry;
        serviceLog = _serviceLog;
        insuranceRecord = _insuranceRecord;
    }

    function verifyVehicle(uint256 tokenId) external view returns (
        address manufacturer,
        string memory name,
        string memory model,
        uint256 year,
        uint256 timeregistered,
        address ServiceProvider,
        uint256 carId,
        uint256 timeServiced,
        string memory nameProvider,
        string memory description,
        string[] memory incidentSummaries
    ) {
        // extract car information
        (manufacturer, name, model, year, timeregistered, ) = serviceLog.getCarDetails(tokenId);
        (ServiceProvider, carId, timeServiced, nameProvider, description) = serviceLog.getServiceDetails(tokenId);
        InsuranceRecord.Incident[] memory incidents = insuranceRecord.getIncidents(tokenId);
        uint256 count = incidents.length;
        incidentSummaries = new string[](count);
        string[] memory insurers = new string[](count);
        uint256[] memory dates = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            incidentSummaries[i] = incidents[i].summary;
            insurers[i] = incidents[i].insurer;
            dates[i] = incidents[i].date;
        }
    }
}

   
