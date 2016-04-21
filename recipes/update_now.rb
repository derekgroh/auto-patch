#
# Cookbook Name:: chef-auto-patch
# Recipe:: update_now
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

if node['auto-patch']['now']
  case node['platform_family']
  when 'rhel'
    execute 'Yum update' do
      command 'yum -y update'
    end
    log 'rhel' do
      level :info
      message 'yum update performed'
    end
  when 'debian'
    execute 'apt-get update' do
      command 'apt-get -q update'
    end
    log 'debian' do
      level :info
      message 'apt-get update performed'
    end
  end
  log 'update-now' do
    level :warn
    message 'All available updates installed'
  end
else
  log 'update-now failed' do
    level :warn
    message "***** WARNING node['auto-patch']['now'] set to false, system not patched *****"
  end
end

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
  end
end
