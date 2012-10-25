class auth_conf {
  include concat::setup

  $auth_conf_path = $puppetversion ? {
    /Puppet Enterprise/ => '/etc/puppetlabs/puppet/auth.conf',
    default             => '/etc/puppet/auth.conf'
  }

  if ! $::custom_auth_conf {
    concat { $auth_conf_path:
      owner => 0,
      group => 0,
      mode  => 600,
    }

    concat::fragment { 'auth_conf_header':
      target  => $auth_conf_path,
      content => template('auth_conf/auth_conf_header.erb'),
      order   => 001,
    }
  } else {
    notify { "The ${$auth_conf::auth_conf_path} file has been manually modified. Refusing to overwrite.": }
  }
}
