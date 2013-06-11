class auth_conf::defaults() {
  include auth_conf

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

  auth_conf::acl { '^/report/([^/]+)$':
    regex      => true,
    acl_method => ['save'],
    allow      => '$1',
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

  auth_conf::acl { '/':
    auth  => 'any',
    order => 100,
  }
}
