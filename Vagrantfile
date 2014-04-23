# -*- mode: ruby -*-
# vi: set ft=ruby tabstop=2 expandtab shiftwidth=2 :
# Vagrant file to build a Pantry Rails application server through Chef.
VAGRANT_API_VERSION = "2"

ruby_file_path = File.expand_path(File.dirname(__FILE__))

apt_cache = ENV['VAGRANT_APT_CACHE'] || File.join(ruby_file_path, "tmp", "apt-cache")
FileUtils.mkdir_p(File.join(apt_cache, "partial"))

repo_path = ENV['REPO_PATH']
cookbooks_path = ::File.join(repo_path, "lakitu", "chef", "cookbooks")
roles_path = ::File.join(repo_path, "lakitu", "chef", "roles")
data_bags_path = ::File.join(repo_path, "lakitu", "chef", "data_bags")
installers_path = ::File.join(repo_path, "winhostconfig")

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.berkshelf.enabled = true
  config.vm.network :private_network, ip: "192.168.33.210"
  config.vm.network :forwarded_port, guest: 8080, host: 18080
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 443, host: 8443
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
  end
  config.vm.synced_folder "#{apt_cache}", "/var/cache/apt/archives/"
  config.vm.provision :shell, :inline => "ulimit -n 8048; apt-get update; apt-get install ruby1.9.3 -y --force-yes"
  config.vm.provision :chef_solo do |chef|
    # chef.cookbooks_path = "#{cookbooks_path}"
    # chef.roles_path = "#{roles_path}"
    # chef.data_bags_path = "#{data_bags_path}"
    chef.log_level = :info
    chef.add_recipe "solo-search"
    chef.add_recipe "pantry::dev_test_packages"
    chef.add_recipe "wonga_splunk::splunk_forwarder_linux"
    # stating recipes for pantry role
    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "users"
    chef.add_recipe "users::sysadmins"
    chef.add_recipe "users::services"
    chef.add_recipe "sudo"
    chef.add_recipe "ntp"
    chef.add_recipe "mysql::server"
    chef.add_recipe "database"
    chef.add_recipe "recipe[pantry::ssh]"
    chef.add_recipe "postfix::client"
    chef.add_recipe "pantry::pantry_knife"
    chef.add_recipe "pantry"
    # ending pantry role
    chef.json = {
      :authorization => {
          :sudo => {
            :groups => [ "sysadmin" ],
            :users => [ "pantry", "vagrant" ],
            :passwordless => true,
            :include_sudoers_d => true
          }
      },
      :build_essential => {
        :compiletime => true
      },
      :mysql => {
        :server_root_password => "pantryroot",
        :server_repl_password => "pantryrepl",
        :server_debian_password => "pantrydebian"
      },
      :pantry => {
        :ssh_configs => [
          {
            :host => '192.168.1.1',
            'StrictHostKeyChecking' => 'no',
            :user => 'vagrant'
          }
        ],
        :app_environment => ENV['ENVIRONMENT'] || "development",
        :app_revision => ENV['GIT_COMMIT'] || "HEAD",
        :app_data_bag => "vagrant",
        :app_data_bag_item => "vagrant",
        :chef_data_bag => "vagrant",
        :chef_data_bag_item => "pantry_knife",
        :chef => {
          :chef_server => "https://chef.example.com",
          :client_key => "-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEA1HjhrNOTAREALKEYoA5okyrBEns0Jps4U+dFWRe3/JAC8cbA\nr4kyqnE0Lssjezs4loTR+4e4eZrdhKxKUsUnj+KEFP3T6Xa5gTiZiTBsdVQe7vj9\nuHITVOCetT22lP/f1E8jZc9jb80odaMjvJ1YT9o1Ecl0lWAGXXCU5RXEeb/qAc2z\n553/+p7PPxJyyn6qwUZ35i8Lo8FLi82F2XodR9APryM4e9KAknOhhHt2kyOUxBsD\nqO/JehRyzUuduFc6Hd36bYLyNubmilhwzJNkKOT44gMfrEV9Hyo5VAh0KejHwDE+\nd6bLKE4IgcWWbw6WwMvfhEtHF63n8Xql+vxPtwIDAQABAoIBABgHo95u5vdcDkQN\nnG1Rs9oRF8zzSi6jl3dFzL4KxLA3yV120QwJREWqj/BK4TRqujerxePgsahvL2Z1\n5eH+kj7fq3iETJc26jwHHrY5V8rdPLJiTq+xlyYeUVTGKgQn/DSSzroQ/noChfTo\nAn6ufPJrB11/n0PVnGKs/On70EDEktX76VSpApcfyYLxKJP0yk4YgO/xgcK1ErID\n8T2VlQFCPgsPZ2uGu1dSjxg3dJYxzpMY1m0JYHUh/bbMGtJl2gQNcc3v4FQo1swa\nVtDjej+xG+/ykX+e4e6xZ0Tue4optS+tGGagePOY1o+EnwEhAWM7yV3l4ynD912F\n7Py2sYECgYEA+8jX3bBmesWLTOsnGouFaH8eAS4VnARUl0HtYdG1Vj96eUSN8ghW\nmyAwyJ7tcZexXdRXemF0G7vF3uqeFJP7n0jx3CGxqtfzGTGLeXMif7Fi7CNkGF6y\nF/fxaeTARmAJ9Or+fsKVk9okqKpPSFmqTg1iQtAAakLgqMYO/ws97IcCgYEA2AeL\nV+xBoamYqv00TolkQBYgwrBHPpIQXmNXzt/h+g0yGyM+19OQqJZkVdScotXsdGJQ\nZq0Ii2T5g7G1WsYdAbDh+Ax8GPMm0S7DMdC6JOAc7wFDYdtPF97aG1bEo8AEs0kr\nSS4yzVaqVgU4L8Ru1b+HkiV3cye5c53n54Bm/1ECgYEA718Yavjj1OCt+Kivense\nkCQaAIExpiwvx8WzywW2YpLi+xuD35Cx1bUa7AC8OPxAcbYInJ695gf0rGNdeq7d\nz6dn2SJnaMb5pQAHW6VsLP4Vz+4toUWWB1d/um7xpXZ0wNYQsa6IyhHgPEH+Mgic\n8quiuWZKnruKHqp9Y1fqvU0CgYEAguwfkMuIAxerhIUrvCUb8pL2i8cVhmAzN2Dx\niFi6tTZmFXhIz7hSRTnP2QyfWThYszgaDf/z27b4WM3MYRUL40h1ykSWuPAzqDa0\n6W3cQhjosBiN47JrvsW6XTM6vRrUPmurphAvja5mUPec06YynawT14iJWerLQ7yB\nHRX+VeECgYEAxnadBCHeiVOwlz+/9FE05IiPfvnFXSKjl4TUHT8ukB6y6nEl3dzo\nHoM1XanctZ10ltmn96upxbD1wdiVm985E57OPOYa6B4p3aKFYfzmvGNqtp57wZSQ\nEP+v2Ng5mjucUeeX6VBm8e+uCIdSvPKHdmouhnveYA6vFmkB/NOTAKEY\n-----END RSA PRIVATE KEY-----",
          :client_name => "pantry"
        },
        :database_master_role => "pantry",
        :omniauth => {
          :title => "Pantry LDAP Login",
          :host => "aws-dcsrv01.example.com",
          :port => 3268,
          :method => :plain,
          :base => "dc=example,dc=com",
          :uid => "sAMAccountName",
          :bind_dn => "some_user@example.com",
          :password => "secret_password",
          :auth_method => :simple
        },
        :aws => {
          :queue_name => "pantry_example_com-ec2_boot_command",
          :chef_env_create_queue_name => "pantry_example_com-ec2_boot_command",
          :flavors => [{ :name => 't1.micro', :size => 80}]
        },
        :api_key => "b00c100c-fbe3-9999-b362-018b5a00009r",
        :webapp => {
          :ssl_enabled => true,
          :ssl_ca_cert => "-----BEGIN CERTIFICATE-----\nMIIDmDCCAoACCQDFKbhYBgCcHjANBgkqhkiG9w0BAQUFADCBjTELMAkGA1UEBhMC\nSUUxEDAOBgNVBAgTB1ZhZ3JhbnQxEDAOBgNVBAcTB1ZhZ3JhbnQxEDAOBgNVBAoT\nB1ZhZ3JhbnQxEDAOBgNVBAsTB1ZhZ3JhbnQxFzAVBgNVBAMTDnBhbnRyeS52YWdy\nYW50MR0wGwYJKoZIhvcNAQkBFg5wYW50cnlAdmFncmFudDAeFw0xMzEwMDExMzQz\nMDZaFw0yMzA5MjkxMzQzMDZaMIGNMQswCQYDVQQGEwJJRTEQMA4GA1UECBMHVmFn\ncmFudDEQMA4GA1UEBxMHVmFncmFudDEQMA4GA1UEChMHVmFncmFudDEQMA4GA1UE\nCxMHVmFncmFudDEXMBUGA1UEAxMOcGFudHJ5LnZhZ3JhbnQxHTAbBgkqhkiG9w0B\nCQEWDnBhbnRyeUB2YWdyYW50MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC\nAQEAliKy/dB9fnw7OhfVcWT4H3TCvla6i0VNTcASrnZMOA3Qhmut/fE5eTU43dM+\n5nPjD9RxhMHTHQHE5lKU7gN9OeLWJ7Bgf2bXeDeOsM2+67h4NRWcvGzTqV2jADxB\nuAk0LJ8VNJr0QnxLEMJQjKbRN1fptKex7PiQRpuJpkQRrSq1f7WCYplOGb0XWJce\n4FmILa170ejQWcIdKID3tIUxRjmtVFZhe1Chctp0GdFAmdi0+dniVXWQ83Z8TRFm\nSxYMGGBwGSk7qhvo8EmML6/xzahcgQt9UiSLbOSHcSIXtCOzK2026loJG3yIk2ie\n0RrPct02RIlBJgNRPV8DNbgIjQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQAsFgOI\nZdPsUqJUvaZUtCoReaOSKgPRsRMx9mlNPbKGU4+tIakG6FUgK7WT3K7FnSxGb2Hg\n0/yyo2X6CCmjo7HNTuQhnFJVL0w+sog+lTNtacRIIlVwk4MSwNSLUMfkqJBodM3A\nvQFpl3O9GWf6h9XxVFUJnwk5VQ2WD00XsoVAkdrry8kL8J78jTaNVhmLRLVi7g8h\niD+ImNZpPxhPfqzGIRgXVG0vy8TfyC4DrLKxfAgJLiRRdeRnJGoeIqZT8kxpfrAk\nEw+5XHpuHQMlGkHsug7digA/Oi0SzAI4PHM6EMPu9619fQWYBA1JnFEJMIdzAD3s\n13ccqcgpEYVacP7N\n-----END CERTIFICATE-----",
          :ssl_cert => "-----BEGIN CERTIFICATE-----\nMIIDmDCCAoACCQDFKbhYBgCcHjANBgkqhkiG9w0BAQUFADCBjTELMAkGA1UEBhMC\nSUUxEDAOBgNVBAgTB1ZhZ3JhbnQxEDAOBgNVBAcTB1ZhZ3JhbnQxEDAOBgNVBAoT\nB1ZhZ3JhbnQxEDAOBgNVBAsTB1ZhZ3JhbnQxFzAVBgNVBAMTDnBhbnRyeS52YWdy\nYW50MR0wGwYJKoZIhvcNAQkBFg5wYW50cnlAdmFncmFudDAeFw0xMzEwMDExMzQz\nMDZaFw0yMzA5MjkxMzQzMDZaMIGNMQswCQYDVQQGEwJJRTEQMA4GA1UECBMHVmFn\ncmFudDEQMA4GA1UEBxMHVmFncmFudDEQMA4GA1UEChMHVmFncmFudDEQMA4GA1UE\nCxMHVmFncmFudDEXMBUGA1UEAxMOcGFudHJ5LnZhZ3JhbnQxHTAbBgkqhkiG9w0B\nCQEWDnBhbnRyeUB2YWdyYW50MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC\nAQEAliKy/dB9fnw7OhfVcWT4H3TCvla6i0VNTcASrnZMOA3Qhmut/fE5eTU43dM+\n5nPjD9RxhMHTHQHE5lKU7gN9OeLWJ7Bgf2bXeDeOsM2+67h4NRWcvGzTqV2jADxB\nuAk0LJ8VNJr0QnxLEMJQjKbRN1fptKex7PiQRpuJpkQRrSq1f7WCYplOGb0XWJce\n4FmILa170ejQWcIdKID3tIUxRjmtVFZhe1Chctp0GdFAmdi0+dniVXWQ83Z8TRFm\nSxYMGGBwGSk7qhvo8EmML6/xzahcgQt9UiSLbOSHcSIXtCOzK2026loJG3yIk2ie\n0RrPct02RIlBJgNRPV8DNbgIjQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQAsFgOI\nZdPsUqJUvaZUtCoReaOSKgPRsRMx9mlNPbKGU4+tIakG6FUgK7WT3K7FnSxGb2Hg\n0/yyo2X6CCmjo7HNTuQhnFJVL0w+sog+lTNtacRIIlVwk4MSwNSLUMfkqJBodM3A\nvQFpl3O9GWf6h9XxVFUJnwk5VQ2WD00XsoVAkdrry8kL8J78jTaNVhmLRLVi7g8h\niD+ImNZpPxhPfqzGIRgXVG0vy8TfyC4DrLKxfAgJLiRRdeRnJGoeIqZT8kxpfrAk\nEw+5XHpuHQMlGkHsug7digA/Oi0SzAI4PHM6EMPu9619fQWYBA1JnFEJMIdzAD3s\n13ccqcgpEYVacP7N\n-----END CERTIFICATE-----",
          :ssl_key => "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAliKy/dB9fnw7OhfVcWT4H3TCvla6i0VNTcASrnZMOA3Qhmut\n/fE5eTU43dM+5nPjD9RxhMHTHQHE5lKU7gN9OeLWJ7Bgf2bXeDeOsM2+67h4NRWc\nvGzTqV2jADxBuAk0LJ8VNJr0QnxLEMJQjKbRN1fptKex7PiQRpuJpkQRrSq1f7WC\nYplOGb0XWJce4FmILa170ejQWcIdKID3tIUxRjmtVFZhe1Chctp0GdFAmdi0+dni\nVXWQ83Z8TRFmSxYMGGBwGSk7qhvo8EmML6/xzahcgQt9UiSLbOSHcSIXtCOzK202\n6loJG3yIk2ie0RrPct02RIlBJgNRPV8DNbgIjQIDAQABAoIBAAdcSiQxbYWe95Rg\niMFXbuaz5bxJKjobuq9+JCxTdmclHj0I2G3jvqqXlmMhsSrBMbeb9bjJe90nMg0M\nrWqB10jYOyGU/xYf555oMuGuJJcP4yzPE3EVcMcT5SLk0WABa4JohjSfCCyeRVvb\n+vD6WLV65OVLd2ijwwcDJxt0qN0xcJzxZotoebvR63RSaFkldXUdtqP4yrhxouCM\nFZTyWcBqEHcuKC+CyzSz5a39TpBbaqc7JhLEfojXsY6I+5LBWv8x9Zm2frtMWnDc\nVj4EkSaNFMGQVCwwkHa9Dggl8xU+sNa3qZos0nuv298wLZfrg+q5wHHmpv8Epo90\nsgYIUSECgYEAxsPJWB5isPSBf5jyEmk4q8BZfMP/xu6hMv+AOZJSKlpBP2hLtIbO\nIoZxcqYgyiS6GHEIt6yuMtGoD1ize6p7xwvHCyzbVKRsEhqaeXCEVc/fzHgakjIT\ngIm2+vVGV3sNYCSsMOrXhk5NXUUgvYWesPLR0ZC+o4nNeHYN5Y5tumkCgYEAwV4k\ndRkG9MQOJ8i9IyEDffb+wxVJJqQRl1yi36zDBrOTAtFM7+jg706kkrX7J680hYk7\nMQpB4sQrIxOOlxFZrAbdsXA9nPCQ3at5H8kQvriGubvjJ8wb05FjggexGwnbb9Yw\n8XRcc/DugdScbxxjMYYL8AER2r+I+5axpTResIUCgYBlbM63Wnn91iaml8MexfaX\nHcYMNm+0cVxsi5hAyHuJBRk6Y9wNuKRDVdtaJ4+f1vHnOva50zHo2LcrbZXYyvvy\na/4bo74gCO7kphKhWVsN9s86pSbZ5xewhZWLpdFJHo+Kuevr4kosTJSJvZahXyfF\nH4MVrwi4pr7kc0lQFEfF0QKBgQCLFxG4XTFAvQnFmkJaU3P0lsc4QkZlEh1JOCw8\nIkQCvQbhPvZNl8C8wl/k3Bv1trRb3ZODOfKckCjLSVUG20caU7IB4U+gZPZ/TMmK\nkJGH7qmSTlEeHlZhv7HJJYlCfrumXXbFJ8Mc7tBQ+UMxNUUwqVBK6ioSpDV/ay0L\nPXljFQKBgQCPoZt8/T9JDSe4KdGzN9Kznj+qv2DbTX8SJ3s22yGD5Rkt9UrLYPIO\nMo2mdXPqMmBidMEVbJKgtaqsEH5FCxKEu52fpfm9NyZZ8sDUPlWF8mzuP2Oo8u8v\n9uGw8Z2SQsQgjvyS1/hNH29CGoprDpObNJTlxpioFSChz1xBmQO96Q==\n-----END RSA PRIVATE KEY-----"
        }
      },
      :passenger => {
        :manage_module_conf => true
      },
      :wonga_windows => {
        :installer_log_path => "C:/Installs/Logs"
      }
    }
  end
end
