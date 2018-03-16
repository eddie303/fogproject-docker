# fogproject-docker

Please make sure that you have NFS support installed on the host and the modules nfs and nfsd are loaded. (In case of Ubuntu, you need the nfs-kernel-server package).
You will need to disable apparmor on mysql on the host if you want to run the built-in mysql server with
# ln -s /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/usr.sbin.mysql

