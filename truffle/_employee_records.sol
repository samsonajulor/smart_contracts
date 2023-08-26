/**
* task: Create a smart contract that showcases various exemplary scenarios by
* utilizing nested structs and mappingswithin a primary struct. 
* Within the main struct, integrate a secondary struct,
* and within this secondary struct, establish a mapping that links it to another struct.
* Moreover, incorporate an enumeration declaration within the main struct. 
* Conclude by implementing a function that allows for the retrieval of information
* from the deepest nested struct."
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeManagement {
    // Enumeration for employee status
    enum Status { Active, Inactive }

    // Struct for main employee record
    struct EmployeeRecord {
        uint employeeId;
        Status status; // enum
        string name;
        uint age;
        EmployeeProfile profile;
    }

    // Struct for employee's profile details
    struct EmployeeProfile {
        string phoneNumber;
        Address contactAddress;
        mapping(uint => JobHistory) jobHistories; // Mapping job history index to JobHistory
    }

    // Struct to store address details
    struct Address {
        string street;
        string city;
        string country;
    }

    // Struct for employee's job history
    struct JobHistory {
        string company;
        uint duration; // in months
    }

    // Mapping to store employee records internally;
    mapping(uint => EmployeeRecord) internal employeeRecords;

        // add employee details
    function addEmployeeDetails(uint _employeeId, string memory _name, uint _age) public {
        employeeRecords[_employeeId].name = _name;
        employeeRecords[_employeeId].age = _age;
    }

    // add profile details for an employee
    function addEmployeeProfile(uint _employeeId, string memory _phoneNumber, string memory _street, string memory _city, string memory _country) public {
        Address memory newAddress = Address(_street, _city, _country);
        employeeRecords[_employeeId].profile.phoneNumber = _phoneNumber;
        employeeRecords[_employeeId].profile.contactAddress = newAddress;
    }

    // add job history for an employee
    function addJobHistory(uint _employeeId, uint _jobIndex, string memory _company, uint _duration) public {
        employeeRecords[_employeeId].profile.jobHistories[_jobIndex] = JobHistory(_company, _duration);
    }

    // retrieve employee details
    function getEmployeeDetails(uint _employeeId) public view returns (string memory, uint) {
        return (employeeRecords[_employeeId].name, employeeRecords[_employeeId].age);
    }

    // retrieve profile details of an employee
    function getEmployeeProfile(uint _employeeId) public view returns (string memory, string memory, string memory, string memory) {
        string memory phoneNumber = employeeRecords[_employeeId].profile.phoneNumber;
        string memory street = employeeRecords[_employeeId].profile.contactAddress.street;
        string memory city = employeeRecords[_employeeId].profile.contactAddress.city;
        string memory country = employeeRecords[_employeeId].profile.contactAddress.country;
        
        return (phoneNumber, street, city, country);
    }

    // retrieve job history details for an employee at a specific index
    function getJobHistoryDetails(uint _employeeId, uint _jobIndex) public view returns (string memory, uint) {
        JobHistory memory history = employeeRecords[_employeeId].profile.jobHistories[_jobIndex];
        return (history.company, history.duration);
    }
}
