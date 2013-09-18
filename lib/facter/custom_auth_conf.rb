unmodified_shas = [
"34aadc7b6d075c5ad742b963734a8dd950da70e1", # 1.2.x auth.conf with console
"ddf2f67ec652c993fb981580113a0d72250c0f42", # 1.2.7 auth.conf with console
"36a1814cc92369841fd21d0ff4b204c922508f16", # 2.0.x auth.conf with console upgraded from 1.2.x
"0d1983136def6909a244d6b1a68d863261343360", # 2.0.x auth.conf with console
"ce5654da6b9b1e3dce3af43181d447dbc27e57bf", # 2.5.x and greater auth.conf with console
"47fa101b6778a29792bbf19880af10f89f26b7be", # 2.7.0 console from auth_conf::defaults
"4c76d6e7955d541025760aaa6107f1cb718bd6cb", # 2.7.0 console defaults from request_manager
"7286b754dae4c45912c9773b68196d79c64b6834", # 2.7.2 console from template
"6dd01047a244c8cbe81c1a87bec57ffa9e662104", # 2.7.2 console from auth_conf::defaults
"406c1d87a802cafca1cd93b88de356e7de45e7ab", # 2.7.2 console from request_manager
"8c69718706850e1383990bc67caf426716ccc9ca", # 2.7.2 console upgraded from 1.2.7
"79ccdd838e8a254d57e53001510002d7235109d2", # 1.2.x auth.conf without console
"f2bfbd8e535c03b61f502d6b194d44faa9d70a42", # 1.2.7 auth.conf master without console
"6a634811f8d4693383f7fd41eb8f9d081e2d5afe", # 2.0.x auth.conf without console upgraded from 1.2.x
"97026c48a979dff803e6a82e313b4980c81dadde", # 2.0.x auth.conf without console
"c269f514bfe182c54ae0f3de72e280554d9d8530", # 2.5.x and greater auth.conf without console
"9704a3ae38f665d90aa45b6ce325c655e9b4b747", # 2.7.0 master without console auth_conf::defaults
"56134dec36bd200d5dd67db356449be7b92b74cd", # 2.7.0 master without console request_manager
"489b1134ddf4eef59a5485e810718d503b9239e0", # 2.7.2 master without console from template
"5be322a869e1d2c63e650a82636198ef2dd66a67", # 2.7.2 master without console from auth_conf::defaults
"66dc5a85e33ba57f4bfe570371c76b43d04e607c", # 2.7.2 master without console from request_manager
"82f1d56e7f69646c7b8bd2687121d31c44ce47b5", # 2.7.2 master upgraded from 1.2.7
"5ef6af4a186f877d7e495a33fc7caa1cc7a2e12a", # 3.0.0 master
"a9e13f5469eebc69b6ad84dfb7e531e41286d643", # 3.0.0 master using auth_conf and request_manager
"e5d11c2d6fbc9135a36c9c54c5fd7da92c42ba60", # 3.0.0 master using auth_conf, request_manager and license_status
]

Facter.add("custom_auth_conf") do
  setcode do
    puppet_version = Facter.value('puppetversion')
    auth_conf_prefix = puppet_version && puppet_version.include?('Puppet Enterprise') ? '/etc/puppetlabs' : '/etc'
    auth_conf_path = "#{auth_conf_prefix}/puppet/auth.conf"

    if File.exists? auth_conf_path
      contents = File.read("#{auth_conf_prefix}/puppet/auth.conf")

      # strip out any comments
      # note that the .map to strip the line is there for
      # normalizing line endings, so we don't have a hell of \r or \n or \r\n
      contents = contents.lines.reject { |line| line =~ /^#.*$/ }.map {|line| line.strip }.join("\n")

      contents.gsub!(/(path\s+\/facts\n(method save\nauth yes|auth yes\nmethod save)\nallow )(.+?)\n/m,'\1')
      new_contents = contents.lines.map { |line| line.strip }.join
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
