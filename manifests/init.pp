# init.pp

class letsencrypt_centralized ( 
  $puppetmaster     = false,
  $puppetmasterhost,
  $certificates     = {},
  $listen_port      = '8080',
  $webroot          = '/etc/letsencrypt/webroot',
  $mastercertfolder = '/etc/puppet/files/letsencrypt', 
  $email,
) {

  validate_hash ( $certificates )

  if $puppetmaster == true {
    # Install let's encrypt client
    class { 'letsencrypt':
      email => $email,
    }
    
    file { "$webroot":
      ensure => 'directory' 
    }
    
    class { 'nginx': 
      vhost_purge => true,
      confd_purge => true,
      require     => File["$webroot"],
    }

    nginx::resource::vhost { $fqdn:
      www_root => $webroot,
      listen_port => $listen_port,
    }

    file { "$mastercertfolder":
      ensure => 'link',
      target => '/etc/letsencrypt/live',
    }
    
    create_resources ( 'letsencrypt_centralized::certificate', $certificates )

  } else {
    create_resources ( 'letsencrypt_centralized::vhost', $certificates )
  }

}
