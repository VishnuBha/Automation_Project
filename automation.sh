#-------------Update apt package-------------
sudo apt update -y
echo "apt package list updated successfully"
#-------------Checking whether Apache install or not, if not Install appache-----------
if [ 'dpkg --get-selections | grep apache |wc =l' > 1 ]
then
	echo "Apache installed already"
else
	sudo apt install apache2 -y
	echo "Apache installed successfully"
fi
#---------------------------------------------------
sudo systemctl unmask apache2
#--------------Check apache running------------
if [ 'service apache2 status | grep running | wc -1' == 1 ]
then
	echo "Apache2 running"
else
	sudo service apache2 start
	echo "Apache2 started"
fi
#-----------Creating tar file in tmp directory-----------
myname="vishnu"
timestamp=$(date '+%d%m%Y-%H%M%S')
cp /var/log/apache2/*.log /tmp/new
cd /tmp
tar -cvf ${myname}-httpd-logs-${timestamp}.tar /tmp/new
ls
echo ${myname}-httpd-logs-${timestamp}.tar "tar file created in tmp directory"
#---------------Archive tar files to AWS S3----------------------
s3_bucket="upgrad-vishnu"
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar  s3://${s3_bucket}/${myname}-http-logs-${timestamp}.tar
echo "Tar file Archived to S3 bucket successfully" ${myname}-httpd-logs-${timestamp}.tar
#-------------------checking inventory.html file present in /var/www/html/inventory.html----------------------
if [ -e /var/www/html/inventory.html ]
then
	echo "Inventory exists"
else
	touch /var/www/html/inventory.html
	echo "Log Type		Time Created		Type		Size" >> /var/www/html/inventory.html
fi
#-----------------Append the Archive detail into inventory.html file--------------------
type_1=`file ${myname}-httpd-logs-${timestamp}.tar | awk '{$3} END {print $3}'`
size=$(ls -lh | grep ${myname}-httpd-logs-${timestamp} | awk '{$4} END {print $5}')

echo "httpd-logs		$timestamp		$type_1		$size" >> /var/www/html/inventory.html
cat /var/www/html/inventory.html
#---------------------Schedule a Cron job if not created-------------------------
if [ -e /etc/cron.d/automation ]
then
	echo "cron schedule presented in etc/cron.d directory"
	cat /etc/cron.d/automation
else
	touch /etc/cron.d/automation
	echo "Schedule cron job"
	echo "* * * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation
	cat /etc/cron.d/automation
fi
#--------------------end od the script------------------
