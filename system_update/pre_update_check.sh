work_dir="/system_upgrade/post"

if [  -d $work_dir ]
then
  rm -rf $work_dir
fi

mkdir $work_dir

echo "-----------------------"
echo "Following are the services listening..."
netstat -plnt | grep -v tcp6 |grep tcp  |grep LISTEN > $work_dir/services_lt
cat $work_dir/services_lt |awk '{print $7}'  |cut -d "/" -f2 |cut -d: -f1
echo "-----------------------"

echo "Current Mount point details...."
df -h |awk '{print $6}' > $work_dir/pre_mnt 
cat $work_dir/pre_mnt
echo "------------------"
