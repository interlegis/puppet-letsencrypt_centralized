# vhost.pp

define letsencrypt_centralized::vhost ( 
  $vhost            = $name,
  $mastercertfolder = $letsencrypt_centralized::mastercertfolder,
  $puppetmasterhost = $letsencrypt_centralized::puppetmasterhost, 
  $puppetmasterport = $letsencrypt_centralized::listen_port, 
  $proxy,
) {

  if exists("${mastercertfolder}/$vhost/cert.pem") {
    certificates::certificate { $vhost:
      source => "puppet:///files/letsencrypt/$vhost/cert.pem",
    }
    certificates::key { $vhost:
      source => "puppet:///files/letsencrypt/$vhost/privkey.pem",
    }

    nginx::resource::vhost { "$vhost":
      proxy              => $proxy,
      ssl                => true,
      listen_port        => 443,
      ssl_port           => 443,
      ssl_cert           => "/etc/ssl/certs/$vhost.crt",
      ssl_key            => "/etc/ssl/private/$vhost.key",
      ssl_stapling       => true,
      proxy_read_timeout => 900,
    }

    nginx::resource::location{"${vhost}-letsencrypt":
      vhost    => $vhost,
      location => '/.well-known/acme-challenge/',
      ssl      => true,
      ssl_only => true,
      proxy    => "http://${puppetmasterhost}:${puppetmasterport}/$vhost/.well-known/acme-challenge/",
    }

  } else {
    nginx::resource::vhost { "$vhost":
      proxy              => $proxy,
      proxy_read_timeout => 900,
    }

    nginx::resource::location{"${vhost}-letsencrypt":
      vhost    => $vhost,
      location => '/.well-known/acme-challenge/',
      proxy    => "http://${puppetmasterhost}:${puppetmasterport}/$vhost/.well-known/acme-challenge/",
    }
  }
}
