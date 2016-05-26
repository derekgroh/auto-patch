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
  when 'ubuntu'

  end
end
