
step "Cleaning up modulepath symlink"

module_path = '/opt/puppet/share/puppet/modules'

on master, "readlink #{module_path}/auth_conf && rm #{module_path}/auth_conf"