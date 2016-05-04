#certificate.pp

define letsencrypt_centralized::certificate (
  $domains = [ "$name" ],
  $webroot = $letsencrypt_centralized::webroot,
) {

  file { "$webroot/$name": ensure => 'directory' }

  letsencrypt::certonly{ "$name":
    plugin          => 'webroot',
    domains         => $domains,
    webroot_paths   => ["$webroot/$name"],
    manage_cron     => true,
  }

} 
