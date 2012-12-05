unmodified_shas = [
"34aadc7b6d075c5ad742b963734a8dd950da70e1", # 1.2.x auth.conf with console
"36a1814cc92369841fd21d0ff4b204c922508f16", # 2.0.x auth.conf with console upgraded from 1.2.x
"0d1983136def6909a244d6b1a68d863261343360", # 2.0.x auth.conf with console
"ce5654da6b9b1e3dce3af43181d447dbc27e57bf", # 2.5.x and greater auth.conf with console
"719db94b35e25d03ae4d52f9d1666653d529ecfa", # 2.7.0 console defaults from request_manager
"79ccdd838e8a254d57e53001510002d7235109d2", # 1.2.x auth.conf without console
"6a634811f8d4693383f7fd41eb8f9d081e2d5afe", # 2.0.x auth.conf without console upgraded from 1.2.x
"97026c48a979dff803e6a82e313b4980c81dadde", # 2.0.x auth.conf without console
"c269f514bfe182c54ae0f3de72e280554d9d8530", # 2.5.x and greater auth.conf without console
"47fa101b6778a29792bbf19880af10f89f26b7be", # 2.7.0 master defaults from auth_conf::defaults
]

Facter.add("custom_auth_conf") do
  setcode do
    puppet_version = Facter.value('puppetversion')
    auth_conf_prefix = puppet_version && puppet_version.include?('Puppet Enterprise') ? '/etc/puppetlabs' : '/etc'
    auth_conf_path = "#{auth_conf_prefix}/puppet/auth.conf"

    if File.exists? auth_conf_path
      contents = File.read("#{auth_conf_prefix}/puppet/auth.conf")

      # strip out any comments
      contents = contents.lines.reject { |line| line =~ /^#.*$/ }.join("\n")

      contents.gsub!(/(path \/facts\nauth yes\nmethod save\nallow )(.+?)\n/m,'\1')
      new_contents = contents.map do |line| line.strip end.join
      if unmodified_shas.include?(Digest::SHA1.hexdigest new_contents)
        'false'
      else
        'true'
      end
    else
      'false'
    end
  end
end
