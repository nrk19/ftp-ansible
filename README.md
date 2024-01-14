# ftp - anonymous + local users

Deployment of a server with two FTP server running on it, and another server that will act as DNS. Both server will use Debian and will be automatically launched and configured using **Vagrant** and **Ansible**.

## Deploy

Using: `make`
Without make: `vagrant up; ansible playbook ansible/site.yml`

## Previous configurations

The FTP server will have two different ftp servers running on it, so the systemd service associated with the 
default vsftpd server needs to be disabled. We will create two new services associated with one ftp server each:
> [!NOTE]
> The default vsftpd service may be used as a template. To obtain it: `systemd cat vsftpd`. 

``` systemd
# File: /etc/systemd/system/vsftpd-ftp.service

[Unit]
Description=Service for the Local User FTP server
After=network.target

[Service]
ExecStart=/usr/sbin/vsftpd /etc/vsftpd/ftp.conf
ExecReload=/bin/kill -HUP $MAINPID
ExecStartPre=/bin/mkdir -p /var/run/vsftpd/empty
KillSignal=SIGTERM
Restart=on-failure
Type=simple

[Install]
WantedBy=multi-user.target
```

Basically we will create two copies of the default vsftpd service with small modifications and place both of then at `/etc/systemd/system/` and then enable both services.

## Servers configuration
