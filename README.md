# ftp - anonymous + local users

## Description
Deployment of a server with two FTP server running on it, and another server that will act as DNS. Both server will use Debian and will be automatically launched and configured using **Vagrant** and **Ansible**.

> The ftp machine will have two network interfaces at the network 192.168.57.0/24 

Network structure:

|     Server     |  Service  |      IP       |
|----------------|-----------| --------------|
| ns.sri.ies     |   named   | 192.168.57.10 |
| mirror.sri.ies |    ftp    | 192.168.57.20 |
| ftp.sri.ies    |    ftp    | 192.168.57.30 |

## Deploy

- Using make: 
    ```bash
    make
    ```
- Without using make: 
    ```bash
    vagrant up
    ansible playbook ansible/site.yml
    ```

## Configuration

### Provisioning
The provisioning will be done using ansible, so we will need to create a ssh key pair and add 
the public key to the file `.ssh/authorized_keys` of both servers. Also we will need to add 
the location of the private key to [ansible.cfg](ansible.cfg) file.

### Previous configuration
Since will have two different ftp servers running on the machine, the systemd service associated with the 
default vsftpd server needs to be disabled. We will create two new 
[services](files/ftp/systemd/vsftpd-ftp.service) associated with one ftp server each, 
basically we will create two copies of the default vsftpd service with small modifications, place both of 
them at `/etc/systemd/system/` and then enable both services.
> [!NOTE]
> The default vsftpd service may be used as a template. To obtain it: `systemctl cat vsftpd`. 

### Directives 
- common directives:
    - `listen`: been set to yes to run the server on standlone mode
    - `listen_address` been set to 192.168.57.20 (network iface corresponding to mirror server)
    - `listen_ipv6` disabled since it conflicts with `listen`
    - `no_anon_password` anon connections won't be prompted for a password
    - `anonymous_enable` disabled anonymous connections (enabled on mirror)
    - `local_enable` enabled local user connections (disabled on mirror)
    - `write_enable` the server will be read-only
    - `data_connection_timeout` unsuccess connections will be cancelled after 30s
    - `anon_max_rate` limit network transfer to 5Mb/s
    - `dirmessage_enable` the content of file .message (if present) will be displayed on new connections
    - `ssl_enable` enabled ssl encryption connection (local users must use it)
    - `rsa_cert_file` location of the public ssl key
    - `rsa_private_key_file` location of the private ssl key

- ftp directives: 
    - `chroot_list_file` file that contents a list of user that will be chrooted [vsftpd.chroot_list](files/ftp/vsftpd.chroot_list)
    - `allow_writeable_chroot` enabled so chrooted user will be able to write in their home directory

- mirror directives: 
    - `allow_anon_ssl` enabled to permit anonymous encrypted connections
    - will be mostly the same but disabling local user connections, and of course no jailed's users list

### SSL Encryption
To encrypt all the data transferations between the server and the client we will use SSL encryption. 
For this porpouse we will generate a pair of keys in the machine using the `openssl` ansible module.

> If we wouldn't use SSL encryption, all the data will be sent as plain text, so anyone sniffing the network
> may be abled to see what's being transfer, and private data may be exposed

Key pair generation at: [ansible/ftp.yml](ansible/ftp.yml)
```yaml
- name: Generate SSL Private Key
    openssl_privatekey:
    path: /etc/ssl/private/ssl-cert-priv.key
    size: 2048

- name: Generate sign request (CSR)
    openssl_csr:
    path: /etc/ssl/private/ssl-sign.csr
    privatekey_path: /etc/ssl/private/ssl-cert-priv.key
    common_name: "ssl-ftp-cert"
    country_name: "ES"
    organization_name: "IES Zaidin Vergeles"
    email_address: "jcorgue951@ieszaidinvergeles.org"
```

## Testing

At [screenshots](screenshots) you can find some captures of the server functionality.