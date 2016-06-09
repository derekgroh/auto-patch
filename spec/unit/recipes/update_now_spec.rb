#
# Cookbook Name:: chef-auto-patch
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'auto-patch::update_now' do
  context 'when on CentOS' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'rhel')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run.to_not raise_error }
    end

    it 'runs an execute `Yum update`' do
      expect do
        chef_run.to run_execute('Yum update').with(
          :command => 'yum -y update'
        )
      end
    end

    it 'writes a log `rhel`' do
      expect do
        chef_run.to write_log('rhel').with(
          :level => ':info',
          :message => 'yum update performed'
        )
      end
    end
  end

  context 'when on Ubuntu' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run.to_not raise_error }
    end

    it 'runs an execute `apt-get update`' do
      expect do
        chef_run.to run_execute('apt-get update').with(
          :command => 'apt-get -q update'
        )
      end
    end

    it 'writes a log `debian`' do
      expect do
        chef_run.to write_log('debian').with(
          :level => ':info',
          :message => 'apt-get update performed'
        )
      end
    end
  end
end
