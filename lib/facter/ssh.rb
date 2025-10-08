Facter.add('ssh_version') do
  setcode do
    next unless Facter::Util::Resolution.which('ssh')

    version_output = Facter::Util::Resolution.exec('ssh -V 2>&1')
    match = version_output&.match(%r{^[A-Za-z0-9._]+SSH[A-Za-z0-9._]+})
    match[0] if match
  end
end

Facter.add('ssh_version_numeric') do
  setcode do
    ssh_version = Facter.value(:ssh_version)
    match = ssh_version&.match(%r{(\d+\.\d+\.\d+|\d+\.\d+)})
    match[0] if match
  end
end
