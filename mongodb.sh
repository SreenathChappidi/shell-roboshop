#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script started executes at: $(date)"


if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root prevelage"
    exit 1 # failure is other than 0
fi

VALIDATE(){ # functions receive inputs through atgs just like shell script
    if [ $1 -ne 0 ]; then
       echo -e "$2 ...$R FAILURE $N"
       exit 1
    else
    echo -e "$2 ...$G  SUCCESS $N"
    fi 
}
cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding Mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installining MongoDB"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "Enable MongoDB"

systemctl start mongod 
VALIDATE $? "Strt MongoDB"
