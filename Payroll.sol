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

    // TODO: Implement a function to add a new employee with salary and check if the employee already exists
    function addEmployee(address worker, uint256 salary) external onlyCompanyOwner returns (bool) {
        require(salary > 0, "Salary must be greater than zero!");
        require(!isEmployee[worker], "Employee already exists!");

        totalEmployees++;
        totalSalary += salary;
        isEmployee[worker] = true;

        // Mark employee as active and record their salary and ID
        employees.push(Employee(totalEmployees, worker, salary, block.timestamp, true));

        emit EmployeeAdded(totalEmployees, worker, salary);
        return true;
    }

    // TODO: Implement a function to deactivate an employee (e.g., termination or leave)
    function deactivateEmployee(address worker) external onlyCompanyOwner returns (bool) {
        require(isEmployee[worker], "Employee does not exist!");

        uint256 index = getEmployeeIndex(worker);
        employees[index].isActive = false;
        isEmployee[worker] = false;

        return true;
    }

    // TODO: Implement a function to check if the payment interval has elapsed since the last payment and only proceed if the interval is met
    function checkPaymentInterval() internal returns (bool) {
        require(block.timestamp >= lastPaymentTime + paymentInterval, "Payment interval not yet reached.");
        return true;
    }

    // TODO: Implement the batch payment process with additional security for preventing reentrancy attacks
    function payEmployees() external payable onlyCompanyOwner returns (bool) {
        require(msg.value >= totalSalary, "Insufficient funds to pay employees.");
        require(totalSalary <= companyBal, "Company balance too low.");
        require(checkPaymentInterval(), "Payment interval has not been reached.");

        // Prevent reentrancy attack: record current state and then pay
        uint256 totalAmountToPay = totalSalary;
        lastPaymentTime = block.timestamp; // Update last payment time
        companyBal -= msg.value;

        // TODO: Write secure logic for paying each employee and logging payments
        for (uint256 i = 0; i < employees.length; i++) {
            if (employees[i].isActive) {
                payTo(employees[i].worker, employees[i].salary);
                lastPaid[employees[i].worker] = block.timestamp; // Record the last payment time
            }
        }

        emit Paid(totalEmployees, companyAcc, totalAmountToPay, block.timestamp);
        return true;
    }

    // TODO: Implement the function to allow the company owner to fund the company balance and keep track of it
    function fundCompanyBalance() external payable onlyCompanyOwner returns (bool) {
        companyBal += msg.value;
        emit PaymentScheduled(lastPaymentTime + paymentInterval);
        return true;
    }

    // TODO: Implement the function to allow the company owner to change the payment interval dynamically
    function updatePaymentInterval(uint256 newInterval) external onlyCompanyOwner {
        require(newInterval > 0, "Interval must be greater than zero.");
        paymentInterval = newInterval;
    }

    function getEmployees() external view returns (Employee[] memory) {
        return employees;
    }

    // TODO: Implement the internal function to safely send money to an employee, ensuring no reentrancy attack
    function payTo(address to, uint256 amount) internal returns (bool) {
        (bool success, ) = payable(to).call{value: amount}("");
        require(success, "Payment failed.");
        return true;
    }

    // Helper function to get employee index by address
    function getEmployeeIndex(address worker) internal view returns (uint256) {
        for (uint256 i = 0; i < employees.length; i++) {
            if (employees[i].worker == worker) {
                return i;
            }
        }
        revert("Employee not found.");
    }

    // TODO: Add additional helper function to manage contract termination (optional)
    // function terminateContract() external onlyCompanyOwner {
    //     selfdestruct(payable(companyAcc));
    // }
}
