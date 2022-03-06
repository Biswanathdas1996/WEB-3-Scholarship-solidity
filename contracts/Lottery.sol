pragma solidity ^0.4.17;
pragma experimental ABIEncoderV2;

contract Lottery {

    struct Student {
        string name;
        uint rollNo;
        uint score;
        bool complete;
        address StudentAddress;
        uint amount;
    }

    struct Depositer {
        uint amount;
        address depositerAddress;
    }

    Depositer[] public depositer;
    Student[] public students;

    address public manager;
    address public winner;
    address[] public players;
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

    function register(string name, uint rollNo, uint score) public payable {
        require(score > 100);
        Student memory newStudent = Student({
            name:name,
            rollNo:rollNo,
            score:score,
            complete:false,
            StudentAddress:msg.sender,
            amount:.1 ether
        });
        students.push(newStudent);
        msg.sender.transfer(.1 ether);
    }

    

    function getListOfStudents() public view returns (Student[]) {
        return students;
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(block.difficulty, now, players));
    }
    
    function pickWinner() public restricted {
        uint index = random() % players.length;
        players[index].transfer(this.balance);
        winner = players[index];
        players = new address[](0);
    }

    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function getPlayers() public view returns (address[]) {
        return players;
    }

    function getWinner() public view returns(address) {
        return winner;
    }
}   