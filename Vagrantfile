# Encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
LOG_LEVEL = :info

Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-omnibus"


chef_run_list = %w[
        logstash::server
        logstash::agent
        kibana::default
]

chef_json = {
    java: {
      jdk_version: '7'
    },
    kibana: {
        webserver_listen: '0.0.0.0',
        webserver: 'nginx',
        install_type: 'file'
    },
    logstash: {
        supervisor_gid: 'adm',
        agent: {
            server_ipaddress: '127.0.0.1',
            xms: '128m',
            xmx: '128m',
            enable_embedded_es: false,
            inputs: [
              file: {
                type: 'syslog',
                path: ['/var/log/syslog', '/var/log/messages'],
                start_position: 'beginning'
              }
            ],
            filters: [
              {
                condition: 'if [type] == "syslog"',
                block: {
                  grok: {
                    match: [
                      'message',
                      "%{SYSLOGTIMESTAMP:timestamp} %{IPORHOST:host} (?:%{PROG:program}(?:\[%{POSINT:pid}\])?: )?%{GREEDYDATA:message}"
                    ]
                  },
                  date: {
                    match: [
                      'timestamp',
                      'MMM  d HH:mm:ss',
                      'MMM dd HH:mm:ss',
                      'ISO8601'
                    ]
                  }
                }
            }
          ]
        },
        server: {
            xms: '128m',
            xmx: '128m',
            enable_embedded_es: true,
            config_templates: ['apache'],
            config_templates_variables: { apache: { type: 'apache' } },
            web: { enable: true }
        }
    }
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Common Settings
  config.omnibus.chef_version = 'latest'
  config.vm.hostname = 'logstash'

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network 'forwarded_port', guest: 9292, host: 9292
  config.vm.network 'forwarded_port', guest: 9200, host: 9200

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, 
    		  '--memory', '1024',
		  '--natdnsproxy1', 'on',
		  '--natdnshostresolver1', 'on']
  end

  config.vm.define :precise64 do |dist_config|
    dist_config.vm.box       = 'opscode-ubuntu-12.04'
    dist_config.vm.box_url   = 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box'

    dist_config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = '/etc/vagrant-chef'
      chef.log_level = LOG_LEVEL
      chef.run_list = chef_run_list
      chef.json = chef_json
      chef.run_list.unshift('apt')
      chef.json[:logstash][:server][:init_method] = 'runit'
    end
  end
end
