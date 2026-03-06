// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdminOnly {
//定义变量
address public  owner;
uint256 public  treasureAmount;
mapping (address =>uint256) public withdrawalAllowance;
mapping (address =>bool) public hasWithdrawn;

//把合同建立者赋值为拥有者

constructor (){
owner =msg.sender;
}

//modifier 是只针对管理员的权限

modifier onlyOwner () {
require(msg.sender ==owner," Access denied:Only the owner can perform this action");
_;        //注意这个语法结构。像德语的可分动词
}

//只有管理员才可以加宝石

function addtreasure (uint256 amount) public onlyOwner {
    treasureAmount +=amount;

}

//只有管理员才可以通过取款申请

function approveWithdrawal (address recipient,uint256 amount) public  onlyOwner {
require (amount <=treasureAmount,"Not enough treasure available");

withdrawalAllowance [recipient]=amount;
}

//任何人都可以触发取款， 但只有有宝石的人才可以领取

function withdrawTreasure (uint256 amount) public {
    if (msg.sender==owner) {
        require(amount <=treasureAmount,"Not enough treasury available for this action.");
        treasureAmount -= amount;
        return;
    }

    uint256 allowance =withdrawalAllowance [msg.sender];

    //在执行上述指令时要先检查以下的三个条件 1.账户有余额， 还没有提取
    require(allowance >0,"You don't have any treasure allowance");
    require(!hasWithdrawn [msg.sender],"You have already withdrwan your treasure/");
    require(allowance >=amount,"Cannot withdraw more than you are allowed");
    //检查提取额度是否大于库存

    //记录提取额度，并减去相应的额度
    hasWithdrawn [msg.sender] = true;
    treasureAmount -=allowance;
    withdrawalAllowance [msg.sender]=0;

}

//只有管理员才可以充值提取额度状态

function resetWithdrawlStatus(address user) public onlyOwner {
    hasWithdrawn[user]= false;
}

//只管理员可以移交账户的所有权

function transferOwnership (address newOwner) public onlyOwner {
    require(newOwner != address (0),"Invalid address");
    owner =newOwner;
}

function getTreasureDetails () public view onlyOwner returns (uint256) {
    return treasureAmount;
}

}