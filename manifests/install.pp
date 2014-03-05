class backuppc-client::install {

  package { "rsync": ensure => present }

  group { "backuppc":
    ensure => present,
    name => "backuppc",
  }

  user { "backuppc":
    ensure => present,
    comment => "Login account for BackupPC",
    gid => "backuppc",
    home => "/home/backuppc",
    managehome => true,
    name => "backuppc",
    shell => "/bin/bash",
    require => Group["backuppc"],
    }

  file { "/home/backuppc":
    ensure => directory,
    mode => 755,
    owner => "backuppc",
    group => "backuppc",
    require => User["backuppc"],
  }

  file { "/home/backuppc/.ssh":
    ensure => directory,
    mode => 700,
    owner => "backuppc",
    group => "backuppc",
    require => File["/home/backuppc"],
  }

  file { "/home/backuppc/.ssh/authorized_keys":
    ensure => present,
    mode => 600,
    owner => "backuppc",
    group => "backuppc",
    require => File["/home/backuppc/.ssh"],
  }

  ssh_authorized_key { "backuppc":
    ensure => present,
    key => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDHvATOQqZjpyxMALwHMWL5woXM87Gos/tmHVZq7g2F4IDYVJwHxHwa0tMnoXycQo5YkBcDcqTtdpjUC2ZwSDm1BhgzqrSNx8j0m7M1rYHYcX3n9GiUqZBROn/VGB/7FRUjq/YIE97D5qwA8yAIWt5h1j7NX5DIyRv3GDAsyuIBF0WtmmbnkGCGEASOWNgJ/UiKaN1FlZt2sUxnKYloTMHhOB07tBHXR198VNqS+BcLnFZ7IDd6f5woOrS1eqAmNuvbyZ8Ngzd8CG1kZjwMERQdp5LmpDTsI6N8soi519yt44e47B2NeevrTD+lv2LYjiZ1tnDUZ1G3Gqg20DwlaWAh",
    name => "backuppc@backup",
    type => "ssh-rsa",
    user => "backuppc",
    require => File["/home/backuppc/.ssh/authorized_keys"],
    }

  file { "/etc/sudoers.d/backuppc":
    owner   => root,
    group   => root,
    mode    => 440,
    content => "backuppc ALL=(ALL) NOPASSWD:/usr/bin/rsync
",
    require => User["backuppc"],
  }

}

