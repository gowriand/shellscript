work_dir="/system_upgrade/post"

while $(sleep 1); do
  echo "Waiting for systemd to finish booting..."
  if systemctl is-system-running | grep -qE "running|degraded"; then
    break
  fi
done

echo "systemd finished booting...Start checks....."

echo "------------------------------"
echo "Host details.."
echo "----"
hostname;  ec2metadata --instance-id
echo "------------------------------"

echo "System Uptime"
echo "----"
uptime
echo "------------------------------"

echo "Check if there is any package upgradable...."
echo "----"
sudo apt-get update
echo "------------------------------"

echo "Checking the service Status..............."
echo "----"
for i in `cat $work_dir/services_lt |awk '{print $7}'  |cut -d "/" -f2 |cut -d: -f1`; do echo "Service $i `systemctl is-active $i`"; done
echo "------------------------------"

echo "Verifying the mount points..................."
echo "----"
df -h |awk '{print $6}' > $work_dir/post_mnt
cmp --silent  $work_dir/pre_mnt $work_dir/post_mnt  && echo "Successfully mounted \n  Current mount details: `cat $work_dir/post_mnt`"  || echo "ERROR: There is a CONFLICT in mount points!!!!\n ----- \n Current_Details  -      Required_Details \n `paste  $work_dir/post_mnt  $work_dir/pre_mnt`"
echo "------------------------------"


