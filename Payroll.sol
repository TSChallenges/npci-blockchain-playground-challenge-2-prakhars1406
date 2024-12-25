// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Payroll {
    address public companyAcc;
    uint256 public companyBal;
    uint256 public totalEmployees = 0;
    uint256 public totalSalary = 0;
    uint256 public lastPaymentTime; // Time of last payment
    uint256 public paymentInterval = 30 days; // Example payment interval (can be modified)
    
    mapping(address => bool) isEmployee;
    mapping(address => uint256) public lastPaid;

    event Paid(uint256 id, address from, uint256 totalSalary, uint256 timestamp);
    event EmployeeAdded(uint256 id, address worker, uint256 salary);
    event PaymentScheduled(uint256 nextPaymentTime);

    struct Employee {
        uint256 id;
        address worker;
        uint256 salary;
        uint256 timestamp;
        bool isActive;
    }

    Employee[] employees;

    modifier onlyCompanyOwner() {
        require(msg.sender == companyAcc, "Only company owner can perform this action");
        _;
    }

    modifier onlyActiveEmployees() {
        require(isEmployee[msg.sender] && employees[getEmployeeIndex(msg.sender)].isActive, "Only active employees can access this");
        _;
    }

    constructor() {
        companyAcc = msg.sender;
        lastPaymentTime = block.timestamp; // Set the initial payment time to now
    }

    // TODO: Add functionality to add a new employee with a salary and check if the employee already exists

    // TODO: Add functionality to deactivate an employee (e.g., termination or leave)

    // TODO: Add functionality to check if the payment interval has elapsed since the last payment

    // TODO: Add functionality to process batch payments securely and prevent reentrancy attacks

    // TODO: Add functionality to allow the company owner to fund the company balance and track it

    // TODO: Add functionality to allow the company owner to update the payment interval dynamically

    function getEmployees() external view returns (Employee[] memory) {
        return employees;
    }

    // TODO: Add an internal function to securely send money to an employee, preventing reentrancy attacks

    // TODO: Add a helper function to get an employee's index by their address

    // TODO: Optionally, add a function to terminate the contract and transfer remaining funds to the company owner
}
