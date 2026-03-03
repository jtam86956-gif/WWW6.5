// SPDX-License-Identifier: MIT
//大家好，这是我的许可证证明

pragma solidity ^0.8.0;  //这是我的版本号

contract SaveMyName {       //我的合约名字

string name;                 //建立字符串形式的变量
string bio;
uint age;        //数字与字符串不同. 一定要记得; 
string job;

function add(string memory _name,//功能窗口add  字符串文件+存储在memory（阅后即焚）memory后面需要有空格+_数据内容
string memory _bio, uint _age, string memory _job) public {
    name =_name;        //把文件放进变量里面
    bio =_bio;
    age =_age;           //记得要加; 
    job =_job;
}

function retrieve()public view     //调取公开可见的值
returns (string memory, string memory, uint, string memory){
    return (name,bio,age,job);
}







}
