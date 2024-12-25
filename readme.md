# Playground Challenge : Payroll System with Batch Payment Processing

## Overview
The Payroll smart contract is a Solidity-based implementation that enables efficient salary management for companies. It allows a company owner to add employees, fund the company balance, and automate salary payments. Designed with security and transparency in mind, it ensures only authorized actions are performed.

## Key Features
1. **Add Employee**: Enables the company owner to add employees with a unique address and specified salary. Prevents duplicate employee entries.
2. **Pay Employees**: Automatically transfers salaries to all employees. Validates that sufficient funds are available before executing payments.
3. **Fund Company Balance**: Allows external accounts to fund the contract, ensuring the company balance is sufficient to pay salaries. Restricts the company owner from funding the contract to separate roles.
4. **Employee Management**: Keeps a secure and accessible record of employees.
5. **Access Control**: Only the company owner can add employees and initiate salary payments.

## Steps to Deploy and Test in Remix IDE
1. **Deploy the Contract**

   * Open Remix IDE and create a new file named `payroll.sol`. Paste the contract code into the file.
   * Compile the contract using a Solidity compiler version compatible with `pragma solidity ^0.8.0` or higher.
   * Deploy the contract in **JavaScript VM** (local testing) or **Injected Web3** (MetaMask integration).
  
2. **Interact with the Contract**:

   * Use the `addEmployee` function to add employees by specifying their address and salary.
   * Fund the contract balance using `fundCompanyBalance` with Ether sent via the value field.
   * Trigger salary payments with the `payEmployees` function.
  
## Test Edge Cases:
1. Attempt to add the same employee twice to confirm error handling.
2. Verify that payments fail when the contract balance is insufficient.

