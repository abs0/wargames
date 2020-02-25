# This is to install the software and also automatic setup/installation

sudo apt-get update
sudo apt install make -y
sudo apt-get install build-essential manpages-dev -y
clear
echo "Checking what version you have for gcc..."
gcc --version
sleep 3
echo ""
sudo apt install inetutils-telnetd -y
clear
sudo echo "telnet stream tcp nowait wopr /.../wargames.sh" >> /etc/inetd.conf
sleep 2
echo "check that the following line is in /etc/inetd.conf"
tail -2 /etc/inetd.conf
read enter
echo "Adding user wopr as it is required..."
sleep 1
sudo adduser wopr
echo "OK!"
sleep 3
sudo usermod -aG sudo wopr
git clone https://github.com/aawheatley/wargames
sudo mv wargames /home/wopr/
cd /home/wopr/wargames
gcc wopr.c wopr
./wopr
sleep 1
sh wargames.sh
