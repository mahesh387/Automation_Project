#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname=mahesh
service=apache2
package=apache2
log_path=/var/log/apache2/
Archiving_dir=/tmp
s3_backuet=s3://upgrad-mahesh
filename=automation.sh
cronpath=/etc/cron.d/automation
temp_path=/tmp
Inputile=/root/Automation_Project/.input-file-name
input_script=.table.sh
mainpath=/root/Automation_Project
varpath=/var/www/html/inventory.html
echo "=============================================================================================================="

#Script updates the package information

echo "==== Auto Run apt-get update ====="

sudo apt update -y

echo "==============================================================================================================="

sleep 1

# Apache2 parckage Install or not condition

sudo dpkg --list | grep $package

echo "================================================================================================================"
sleep 1
# Script ensures that HTTP Apache server is running

echo "====Staus of apache2.service ====="

sudo ps cax | grep $package
if [ $? -eq 0 ]; then
 echo "$package Process is running."
else
 echo "$package Process is not running."
fi

sleep 1

echo "=================================================================================================================="

# Script ensures that HTTP Apache service is enabled

echo "==== Enabling of apache2.service ====="

sudo systemctl enable  $service

sudo systemctl status  $service | grep "enable"


echo "====================================================================================================================="

sleep 1

# After executing the script the tar file should be present in the correct format in the /tmp/ directory Tar should be copied to the S3 bucket

echo "===== Compressing Aapache2 log ====="

sudo tar -cvf $Archiving_dir/$myname-httpd-logs-$timestamp.tar $log_path

echo "==========================================================================================================================================="

# The script should run the AWS CLI command and copy the archive to the s3 bucket. 

echo "$myname-httpd-logs-$timestamp.tar file uploading to s3 backert ........."

aws s3 cp $Archiving_dir/$myname-httpd-logs-$timestamp.tar $s3_backuet/$myname-httpd-logs-$timestamp.tar

echo "$myname-httpd-logs-$timestamp.tar file uloading done  s3 backet"


echo "============================================================================================================================================="
sleep 1

echo "===== If check automcation script  cron present or not ======="

if /bin/cat $cronpath  | grep -i $filename; then
        echo "$filename cron is present"
else
        echo "$filename cron is not present"
fi

echo "============================================================================================================================================="
exit
