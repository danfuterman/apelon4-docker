# Download apelon from http://www.apelondts.org/Downloads/Software.aspx
# Register on the site, then download version dts-linux_4.6.0-798.tar.gz and place the file inside of the 'files' folder.

# Build container
sudo docker build -t="opencds/apelon:ubuntu" .

# Run container
sudo docker run -d -P --name apelon opencds/apelon:ubuntu

# You can access the DTS Browser from: http://[container ip address]:8080/dtsserverws
# You can get the container ipaddres with the following command
sudo docker inspect apelon | grep "IPAddress"

# To login to the DTS Browser, you will need to enter the user credentials either
# dtsadminuser/dtsadmin or dtsuser/dts.  Please see dts4_installationGuide.pdf for more details





