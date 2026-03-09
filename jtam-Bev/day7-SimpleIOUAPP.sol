// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleIOU {
address public owner;

//记录已注册的朋友
mapping (address =>bool) public  registeredFriends;
address [] public  friendList;

//记录账户余额
mapping (address =>uint256) public balances;

//简单的债务记录
mapping (address =>mapping (address =>uint256)) public debts;
//复合映射 债务人的地址以及欠款额 债权人的地址

constructor () {
    owner=msg.sender;
    registeredFriends [msg.sender]=true;
    friendList.push (msg.sender);
    //把owner记录在朋友清单里
}

modifier onlyOwner () {
    require(msg .sender == owner, "Only owner can perform this action");
    _;
}

//加一个控制器 只有户主可以修改

modifier onlyRegistered () {
    require (registeredFriends [msg.sender], "You are not registered.");
    _;
}

//加一个控制器。只有注册过的人才可以操作


//添加朋友。新朋友 

function addFriend (address _friend) public onlyOwner {
    require(_friend != address (0), "Invlid address.");
    require(!registeredFriends[_friend],"Friend already registered");
}

//存钱入余额   

function depositintoWallet () public payable onlyRegistered {
    require(msg .value>0, "Must send ETH.");

    balances[msg. sender] += msg.value;
}


//记录别人欠你的帐 （账户地址和金额）

function recordDebt (address _debtor, uint256 _amount) public  onlyRegistered {

    require(_debtor !=address (0), "Invalid address.");

    require(registeredFriends [_debtor], "Address not registered.");

    require(_amount>0, "Amount must be greater than 0.");

//三个守门员 三个条件 账户存在。是否登记在册。金额是否大于零

debts[_debtor][msg.sender] +=_amount;
}
//用内部系统还账 （这是一个充值系统）

function payFromWallet (address _creditor,  uint256 _amount) public onlyRegistered {
require(_creditor!=address(0),"Invalid address.");
require(registeredFriends[_creditor],"Creditor not registered.");
require(_amount>0,"Amount must greater than 0.");
require(debts[_creditor][msg.sender] >=_amount, "Debt amount incorrect.");
require(balances[msg.sender] >=_amount, "insufficient balance.");

//更新余额和债务

balances [msg.sender] -=_amount;
balances [_creditor] +=_amount;
debts[msg.sender][_creditor] -=_amount;
}


//直接转账方法要用transfer9函数

function transferEther(address payable _to, uint256 _amount) public onlyRegistered {
require(_to !=address(0), "Invalid address.");
require(registeredFriends[_to], "Recipient not registered.");
require(balances[msg.sender] >= _amount, "Insufficient balance.");
balances[msg.sender] -= _amount;
_to.transfer (_amount);
balances[_to] += _amount;
}

//可替换的转账函数用call。 我的问题：这是不是bala在视频里提到的矿工会抢相关：因为transfer的打包费很便宜时效低

function transferEtherViaCall (address payable  _to, uint256 _amount) public onlyRegistered {

 require(_to !=address(0), "Invalid address.");

require(registeredFriends[_to], "Recipient not registered.");

require(balances[msg.sender] >=_amount, "Insufficient balance.");

balances[msg.sender] -=_amount;

(bool success,) =_to.call{value:_amount} ("");

balances[_to] +=_amount;

require(success, "Transfer failed.");

}

//提取你的余额

function withdraw (uint256 _amount) public onlyRegistered {

require(balances [msg.sender]>= _amount, "Insufficient balance.");

balances[msg.sender]-= _amount;

(bool success,) = payable (msg.sender).call{value:_amount} ("");

require(success, "Withdrawl failed.");

}

//检查余额

function checkBalance () public view onlyRegistered returns (uint256) {
    return  balances[msg.sender];
}
}

   


