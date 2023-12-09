// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProjectPayment {
 address payable public employer;
 address payable public employee;
 uint public price;
 uint public deadline;
 bool public taskCompleted;
 event CompleteTask(uint time, uint taskNumber);
 event Canceled(uint time);
 event Claimed(uint time, uint taskNumber);

 constructor(address payable _employer, address payable _employee, uint _deadline) payable  {
    employer = _employer;
    employee = _employee;
    deadline = block.timestamp + _deadline;
    price = msg.value;
 }

 function completeTask(uint _taskNumber) public {
    require(msg.sender == employer, "Only the employer can approove completion the task.");
    taskCompleted = true;
    emit CompleteTask(block.timestamp, _taskNumber);
 }

 function cancel() public {
    require(msg.sender == employer, "Only the employer can cancel the contract.");
    require(!taskCompleted, "The Task is completed and you approved it.");
    require(block.timestamp > deadline, "deadline is not yet reached.");
    uint amount = price;
    price = 0;
    employer.transfer(amount);
    emit Canceled(block.timestamp);
 }

 function claimPayment(uint _taskNumber) public {
    require(msg.sender == employee, "Only the employee can claim the payment.");
    require(block.timestamp > deadline, "Deadline must be passed before payment can be claimed.");
    require(taskCompleted == false, "Task must not be completed before payment can be claimed.");
    uint amount = price;
    price = 0;
    employee.transfer(amount);
    emit Claimed(block.timestamp, _taskNumber);

 }
}
