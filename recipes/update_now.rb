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
  else
    log 'update-now failed - platform_family' do
      level :warn
      message '***** WARNING platform_family not recognized - update failed *****'
    end
  end
else
  log 'update-now failed' do
    level :warn
    message "***** WARNING node['auto-patch']['now'] set to false, system not patched *****"
  end
end
