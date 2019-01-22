# fogproject-docker

Please make sure that you have NFS support installed on the host and the modules nfs and nfsd are loaded. (In case of Ubuntu, you need the nfs-kernel-server package). If you intend to run the container on Ubuntu, you can achieve this by appending to /etc/modules.
	
	sudo echo "nfs" >> /etc/modules
	sudo echo "nfsd" >> /etc/modules
 
You will need to disable apparmor on mysql on the host if you want to run the built-in mysql server with

	ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/usr.sbin.mysql

The file start-fog.sh is a way to start the container. dhcpd is intended to run outside the container, hence the given configuration file.
Great thanks to Tortuginator for the Python script!

