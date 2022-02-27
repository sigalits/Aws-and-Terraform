#! /bin/bash
echo "Installing nginx"
sudo yum install -y epel-release
sudo yum update -y
#sudo yum install nginx -y
#echo "<h1>Welcome to Grandpa's Whiskey </h1>" | sudo tee /usr/share/nginx/html/index.html
#sudo systemctl start nginx
#sudo systemctl enable nginx
echo "Mount /data"
sudo mkfs -t xfs /dev/nvme1n1
sudo mkdir /data
sudo mount /dev/nvme1n1 /data
echo "add to fstab"
UUID=`sudo blkid | grep nvme1n1 | awk  -F\" '{print $2}'\n`
echo "UUID=${UUID}  /data  xfs  defaults,nofail  0  2" | sudo tee -a /etc/fstab