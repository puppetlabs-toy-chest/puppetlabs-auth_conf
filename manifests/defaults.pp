class auth_conf::defaults($inventory = false, $console_master_certname = $certname) {
  include auth_conf

  if $fact_is_puppetconsole == 'true' and $inventory == false {
    $real_inventory = true
  } else {
    $real_inventory = false
  }

  auth_conf::acl { '^/catalog/([^/]+)$':
    regex      => true,
    acl_method => ['find'],
    allow      => '$1',
    order      => 010,
  }

  auth_conf::acl { '^/node/([^/]+)$':
    regex      => true,
    acl_method => ['find'],
    allow      => '$1',
    order      => 020,
  }

  auth_conf::acl { '/certificate_revocation_list/ca':
    acl_method => ['find'],
    allow      => '*',
    order      => 030,
  }

  auth_conf::acl { '/report':
    acl_method => ['save'],
    allow      => '*',
    order      => 040,
  }

  auth_conf::acl { '/file':
    allow => '*',
    order => 050,
  }

  auth_conf::acl { '/certificate/ca':
    allow      => '*',
    auth       => 'any',
    acl_method => ['find'],
    order      => 060,
  }

  auth_conf::acl { '/certificate/':
    auth       => 'any',
    acl_method => ['find'],
    allow      => '*',
    order      => 070,
  }
  
  auth_conf::acl { '/certificate_request':
    auth       => 'any',
    acl_method => ['find','save'],
    allow      => '*',
    order      => 080,
  }

  if $real_inventory {
    auth_conf::acl { 'find-search-/facts':
      path       => '/facts',
      auth       => 'any',
      acl_method => ['find','search'],
      allow      => '*',
      order      => 090,
    }

    auth_conf::acl { 'save-/facts':
      path       => '/facts',
      auth       => 'yes',
      acl_method => ['save'],
      allow      => $console_master_certname,
      order      => 095,
    }
  }

  auth_conf::acl { '/':
    auth  => 'any',
    order => 100,
  }
}
