pragma solidity ^0.4.17;
pragma experimental ABIEncoderV2;

contract Lottery {

    struct Student {
        uint slNo;
        string name;
        uint rollNo;
        string dob;
        uint score;
        bool complete;
        address StudentAddress;
        uint amount;
        uint otp;
    }

    struct Vendor {
        uint slNo;
        string name;
        string registrationNo;
        string vendorAddress;
        uint pincode;
        address vendorWalletAddress;
        bool status;
        address approverAddress;
        uint amount;
    }

    struct DeviceIssue {
        string name;
        string vendorName;
        uint vendorIndex;
        uint rollNo;
        string deviceIMEI;
        uint amount;
        string remark;
    }

    struct Depositer {
        uint amount;
        address depositerAddress;
    }

    Depositer[] public depositer;
    Student[] public students;
    Vendor[] public vendors;
    DeviceIssue[] public deviceIssue;

    address public manager;
    address[] public rechargeAddress;
    uint public scholarshipAmout;
    uint public minimumScore;
    uint public amount;
    
    function Lottery() public {
        manager = msg.sender;
        
    }
    
   function enter() public payable {
       Depositer memory newDepositer = Depositer({
            amount:msg.value,
            depositerAddress:msg.sender
        });
       depositer.push(newDepositer);
    }

    function getListOfDepositors() public view returns (Depositer[]) {
        return depositer;
    }

    function registerStudent(string name, uint rollNo, uint score, string dob) public payable {
        require(score > 100);
        Student memory newStudent = Student({
            slNo:students.length,
            name:name,
            rollNo:rollNo,
            dob:dob,
            score:score,
            complete:false,
            StudentAddress:msg.sender,
            amount:1000000000000000000,
            otp:uint(keccak256(block.difficulty, now))
        });
        students.push(newStudent);
    }



    function registerVendor(string name, string registrationNo, string vendorAddress, uint pincode) public payable {
        Vendor memory newVendor = Vendor({
            slNo:vendors.length,
            name:name,
            registrationNo:registrationNo,
            vendorAddress:vendorAddress,
            pincode:pincode,
            vendorWalletAddress:msg.sender,
            status:false,
            approverAddress:0X00,
            amount:0
        });
        vendors.push(newVendor);
    }

    

    function issueNewDevice(string deviceIMEI, uint studentIndex, uint otp, uint vendorIndex, uint amount, string remark) public payable {

        Student storage studentsData = students[studentIndex];
        Vendor storage currentVendorData = vendors[vendorIndex];

        require(studentsData.otp == otp);
        require(currentVendorData.status == true);

        DeviceIssue memory issueNewDevice = DeviceIssue({
            name:studentsData.name,
            rollNo:studentsData.rollNo,
            deviceIMEI:deviceIMEI,
            amount:amount,
            vendorIndex:vendorIndex,
            vendorName:currentVendorData.name,
            remark:remark
        });
        deviceIssue.push(issueNewDevice);
       
       currentVendorData.amount = currentVendorData.amount + amount;
       studentsData.amount = studentsData.amount - amount;
       msg.sender.transfer(amount);
    }

    function approveVendor(uint vendorIndex) public payable {
       
       Vendor storage currentVendorData = vendors[vendorIndex];
       currentVendorData.status = true;
       currentVendorData.approverAddress = msg.sender;

    }

    function rejectVendor(uint vendorIndex) public payable {
       
       Vendor storage currentVendorData = vendors[vendorIndex];
       currentVendorData.status = false;
       currentVendorData.approverAddress = msg.sender;

    }
    

    function getListOfStudents() public view returns (Student[]) {
        return students;
    }

    function getListOfVendors() public view returns (Vendor[]) {
        return vendors;
    }

    function getListOfDeviceIssue() public view returns (DeviceIssue[]) {
        return deviceIssue;
    }

   
    
    
   

    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    

    
}   