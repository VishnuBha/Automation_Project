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
cd /tmp/
tar -cvf ${myname}-httpd-logs-${timestamp}.tar new
ls
echo ${myname}-httpd-logs-${timestamp}.tar "tar file created in tmp directory"
#---------------Archive tar files to AWS S3----------------------
s3_bucket="upgrad-vishnu"
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar  s3://${s3_bucket}/${myname}-http-logs-${timestamp}.tar
echo "Tar file Archived to S3 bucket successfully" ${myname}-httpd-logs-${timestamp}.tar
