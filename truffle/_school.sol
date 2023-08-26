// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

// write a contract for handling student details where the details of a specific student can be updated or deleted by admin. and anyone can query the details for each student.

contract School {
        constructor() {
        administrators[msg.sender] = true;
    }
 struct Student {
  address id;
  string name;
  uint age;
  string department;
 }

 mapping(address => Student) public students;

 mapping(address => bool) public administrators;

 modifier onlyAdmin() {
  require(administrators[msg.sender] == true, "only admin is allowed");
  _;
 }

 function addStudent(address _id, string memory _name, uint _age, string memory _department) public onlyAdmin {
  students[_id] = Student(_id, _name, _age, _department);
 }

 function updateStudent(address _id, string memory _name, uint _age, string memory _department) public onlyAdmin {
  students[_id] = Student(_id, _name, _age, _department);
 }

 function updateAge(address _id, uint _age) public onlyAdmin {
  students[_id].age = _age;
 }

 function updateDepartment(address _id, string memory _department) public onlyAdmin {
  students[_id].department = _department;
 }

 function updateName(address _id, string memory _name) public onlyAdmin {
  students[_id].name = _name;
 }

 function deleteStudent(address _id) public onlyAdmin {
  delete students[_id];
 }

 function addAdmin(address _id) public onlyAdmin {
  administrators[_id] = true;
 }

 function removeAdmin(address _id) public onlyAdmin {
  delete administrators[_id];
 }
}