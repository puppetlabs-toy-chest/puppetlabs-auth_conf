define auth_conf::acl(
  $path = 'UNSET',
  $acl_method = undef,
  $allow  = [],
  $auth   = 'yes',
  $order  = '99',
  $regex  = false,
  $environment = undef,
) {

  if ! $::custom_auth_conf {
    if $path == 'UNSET' {
      $real_path = $name
    } else {
      $real_path = $path
    }

    validate_re( $auth, '(yes|no|on|off|any)')

    concat::fragment { $title:
      target  => $auth_conf::auth_conf_path,
      content => template('auth_conf/auth_conf_acl.erb'),
      order   => $order,
    }
  } else {
    notify { "The ${$auth_conf::auth_conf_path} file has been manually modified. Refusing to overwrite.": }
  }
}
