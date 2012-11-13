
require 'lib/puppet_acceptance/dsl/install_utils'

extend PuppetAcceptance::DSL::InstallUtils

step "Linking auth_conf module in to modulepath"

module_path = '/opt/puppet/share/puppet/modules'

on master, "ln -f -s #{SourcePath}/auth_conf #{module_path}"