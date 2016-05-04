# puppet-letsencrypt_centralized
Puppet module to request Letsencrypt certificates from Puppet Master and distribute to your webservers

Uses jfryman/puppet-nginx and danzilio/puppet-letsencrypt to request and store certificates in the puppet master and distribute them to an nginx SSL proxy.

To use this module you need to configure /etc/puppet/fileserver.conf to allow Puppet client access to static files in /etc/puppet/files folder.

```
[files]
  path /etc/puppet/files
  allow \*.your.machines.puppet.domain
```

