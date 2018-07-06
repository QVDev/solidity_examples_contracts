pragma solidity ^0.4.7;

/// @title A simple bike insurance contract
/// @author QVDev
/// @dev deployed at https://ropsten.etherscan.io/address/0xaa93fe5d043417d15aa2f322bdeac6d1c2f65f0a
contract BikeInsurance {

    struct Bike {
        uint serialnumber;
    }
    struct Customer {
        uint age;
    }
    
    struct Insurance {
        address ownerAddress;
        Bike bike;
        Customer customer;
    }

    mapping(uint => Insurance) insurances;
    uint _minimumAge = 18;
    
    /// @dev Check if bike and customer are legible for insurance
    modifier eligible(uint _age, uint _serialnumber) {
        require(insurances[_serialnumber].bike.serialnumber == 0,"Bike is already insured with a customer");
        require(_age >= _minimumAge,"Owner is not old enough. Should be 18 years or older");
        _;
    }

    /// @dev create a new insurance and save to insurances
    /// @dev _age should be converted to be timestamp compatible
    function applyForInsurance(uint _age, uint _serialnumber) public eligible(_age, _serialnumber) payable {
        Bike memory bike = Bike(_serialnumber);
        Customer memory customer = Customer(_age);
        Insurance memory newInsurance = Insurance(msg.sender, bike, customer);
        
        insurances[_serialnumber] = newInsurance;
    }
    
    /// @dev make sure that it is the owner of the bike insurance
    modifier ownerOnly(uint _serialnumber, address _owner)  {
        require(insurances[_serialnumber].ownerAddress == _owner, "Not the owner of bike insurance");
        _;
    }
    
    /// @dev cancel a bike insurance
    function cancelInsurance(uint _serialnumber) public ownerOnly(_serialnumber, msg.sender) {
        delete insurances[_serialnumber];
    }
    
    /// @dev Check if the customer is eligible to get a insurance for the bike
    function checkIfEligible(uint _age, uint _serialnumber) external view eligible(_age, _serialnumber) returns(bool) {
        return true;   
    }
}
