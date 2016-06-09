#
# Cookbook Name:: auto-patch
# Recipe:: update_once
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

if node['auto-patch']['once']
  case node['platform_family']
  when 'rhel'
    package 'at' do
      action :install
    end
    service 'atd' do
      action :start
    end
    execute 'at yum update' do
      command 'echo "sudo yum -y update" | at now'
    end
    log 'rhel' do
      level :info
      message 'echo "sudo yum -y update" | at now executed'
    end
  when 'ubuntu'
    execute 'at apt-get -q update' do
      command 'echo "sudo apt-get -q update" | at now'
    end
    log 'debian' do
      level :info
      message 'echo "sudo apt-get -q update" | at now'
    end
  else
    log 'update-once failed - platform_family' do
      level :warn
      message '***** WARNING platform_family not recognized - update failed *****'
    end
  end
else
  log 'update-once failed' do
    level :warn
    message "***** WARNING node['auto-patch']['once'] set to false, system not patched *****"
  end
end
