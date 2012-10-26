class auth_conf {
  include concat::setup

  $auth_conf_path = $puppetversion ? {
    /Puppet Enterprise/ => '/etc/puppetlabs/puppet/auth.conf',
    default             => '/etc/puppet/auth.conf'
  }


  if $::custom_auth_conf == false {
    include auth_conf::modified_warning
  } else {
    concat { $auth_conf_path:
      owner => 0,
      group => 0,
      mode  => 644,
    }

    concat::fragment { 'auth_conf_header':
      target  => $auth_conf_path,
      content => template('auth_conf/auth_conf_header.erb'),
      order   => 001,
    }
  }
}
