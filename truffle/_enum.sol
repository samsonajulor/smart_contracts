// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// enum sample with get, set, cancel, and delete functions
contract Enum {
    enum Status { Pending, Shipped, Accepted, Rejected, Canceled }
    Status public status;

    function get() public view returns (Status) {
        return status;
    }
    // return the current status and the string representation of the status
    function getWithStrings() public view returns (Status, string memory) {
        if (status == Status.Pending) {
            return (status, "Pending");
        } else if (status == Status.Shipped) {
            return (status, "Shipped");
        } else if (status == Status.Accepted) {
            return (status, "Accepted");
        } else if (status == Status.Rejected) {
            return (status, "Rejected");
        } else if (status == Status.Canceled) {
            return (status, "Canceled");
        }
        return (status, "Pending");
    }
    function set(Status _status) public {
        status = _status;
    }
    function cancel() public {
        status = Status.Canceled;
    }
    function reset() public {
        delete status;
    }
}