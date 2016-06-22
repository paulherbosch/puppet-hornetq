require 'spec_helper_acceptance'

describe 'hornetq' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        include yum
        include stdlib
        include stdlib::stages
        include profile::package_management
        class { 'cegekarepos' : stage => 'setup_repo' }
        Yum::Repo <| title == 'cegeka-custom' |>
        Yum::Repo <| title == 'cegeka-custom-noarch' |>
        Yum::Repo <| title == 'cegeka-unsigned' |>
        Yum::Repo <| title == 'epel' |>
        sunjdk::instance { 'jdk1.8.0_40':
          ensure      => 'present',
          pkg_name    => 'jdk1.8.0_40',
          jdk_version => '1.8.0_40-fcs',
          versionlock => true
        }

        $link = 'hornetq24'

        file { '/data':
          ensure => 'directory'
        }
        file { '/data/logs':
          ensure => 'directory'
        }
        file { '/opt/hornetq':
          ensure  => link,
          target  => "/opt/${link}",
          require => Class['::hornetq']
        }
        file { '/var/log/hornetq':
          ensure  => link,
          target  => "/var/log/${link}",
          require => File['/opt/hornetq']
        }
        file { '/etc/systemd/system/hornetq.service':
          ensure  => link,
          target  => "/usr/lib/systemd/system/${link}.service",
          require => File['/var/log/hornetq']
        }
        class { 'hornetq':
          version             => '2.4.0-5.cgk.el7',
          service_state       => 'running',
          java_home           => '/usr/java/jdk1.8.0_77',
          ping_timeout        => '120',
          ping_timeout_action => 'NONE'
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    describe package('hornetq') do
      it { should be_installed }
    end
    describe service('hornetq') do
      it { should be_running }
    end
  end
end
