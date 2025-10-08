Facter.add('ssh_version') do
  setcode do
    next unless Facter::Util::Resolution.which('ssh')

    version_output = Facter::Util::Resolution.exec('ssh -V 2>&1')
    next unless version_output

    tokens = version_output.split(/[,\s]+/)
    token_pattern = %r{\A[A-Za-z0-9._+-]*SSH[A-Za-z0-9._+-]*\z}

    preferred_version = tokens.find do |token|
      token.match?(token_pattern) && token.match?(%r{\A(?:Open|Sun_)?SSH})
    end

    preferred_version ||= tokens.filter_map do |token|
      next unless token.include?('OpenSSH_')

      token[%r{OpenSSH_[A-Za-z0-9._+-]*}]
    end.first

    preferred_version ||= tokens.filter_map do |token|
      next unless token.include?('Sun_SSH_')

      token[%r{Sun_SSH_[A-Za-z0-9._+-]*}]
    end.first

    preferred_version || tokens.find { |token| token.match?(token_pattern) }
  end
end

Facter.add('ssh_version_numeric') do
  setcode do
    ssh_version = Facter.value(:ssh_version)
    match = ssh_version&.match(%r{(\d+\.\d+\.\d+|\d+\.\d+)})
    match[0] if match
  end
end
