
test_name 'Having a modified auth.conf should show a warning and not modify auth.conf'

teardown do
  step 'Restoring auth.conf'
  on master, "cp #{AUTH_CONF_BACKUP_PATH} #{AUTH_CONF_PATH}"
end

step 'Modifying auth.conf'

on master, "echo MODIFIED > #{AUTH_CONF_PATH}"

step 'Running "include auth_conf"'

apply_manifest_on master, 'include auth_conf::defaults', {:catch_failures => true} do
  fail_test('no warning was emitted for a modified auth.conf when using "include auth_conf"') unless result.output.include? 'file has been manually modified. Refusing to overwrite.'
end

step 'Running "auth_conf::acl"'

acl = <<-eos
auth_conf::acl { '/test_endpoint':
  auth       => 'yes',
  acl_method => ['find','search', 'save', 'destroy'],
  allow      => 'pe-internal-dashboard',
  order      => 085,
}
eos

apply_manifest_on master, acl, {:catch_failures => true} do
  fail_test('no warning was emitted for a modified auth.conf when using "auth_conf::acl"') unless result.output.include? 'file has been manually modified. Refusing to overwrite.'
end
