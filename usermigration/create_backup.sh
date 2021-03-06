#!/bin/bash

#read -p "Enter Home Dir : " -r  HOM_DIR
read -p "Enter Backup Dir : " -r  BK_DIR
HOM_DIR='/home'
#BK_DIR='/meltwater/backup'

  if [ -d $BK_DIR ]
  then
     rm -r $BK_DIR
     echo "Deleted bkp dir"
  fi

mkdir $BK_DIR
#####################Get users list ##########################
getusers()
{
  touch $BK_DIR/userlist

  for i in `ls -al  $HOM_DIR |awk '{print $3}' | sed '/redux\|root/d'`
  do 
     #echo $i
     if grep -q "$i:" /etc/passwd 
     then 
        echo "Need to sync User : $i " 
        echo "$i" >> $BK_DIR/userlist
     else  
	echo "Already deleted User : $i " 
     fi 
  done
}

##########Create backup###############################
createbkp()
{
 touch $BK_DIR/addpasswd $BK_DIR/addgroup $BK_DIR/addshadow $BK_DIR/addgshadow
 mkdir $BK_DIR/home
 for i in `cat $BK_DIR/userlist`
 do 
  echo "Creating Backup of config and home : $i";
  grep "$i" /etc/passwd |grep -v wheel >> $BK_DIR/addpasswd
  grep "$i" /etc/group |grep -v wheel >> $BK_DIR/addgroup
  grep "$i" /etc/shadow |grep -v wheel >> $BK_DIR/addshadow
  grep "$i" /etc/gshadow |grep -v wheel >> $BK_DIR/addgshadow
  grep wheel /etc/group  > $BK_DIR/addgroup_wheel
  grep wheel /etc/gshadow  > $BK_DIR/addgshadow_wheel

  cp -rpf $HOM_DIR/$i $BK_DIR/home/.
 done
 echo "____" 
 echo "Backup generation completed"
 echo "____________________________________________"
}

###############
getusers
createbkp
echo "Use command 'rsync -avz $BK_DIR  user@destn_server:/PATH' to copy backup to destination box"
echo "____________________________________________________"
