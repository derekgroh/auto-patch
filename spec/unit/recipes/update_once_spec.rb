#
# Cookbook Name:: auto-patch
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'auto-patch::update_once' do
  context 'when on CentOS' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'rhel')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run.to_not raise_error }
    end

    it 'installs a package `at`' do
      expect { chef_run.to install_package('at') }
    end

    it 'starts a service `atd`' do
      expect { chef_run.to start_service('atd') }
    end

    it 'runs an execute `at yum update`' do
      expect do
        chef_run.to run_execute('at yum update').with(
          :command => 'echo "sudo yum -y update" | at now'
        )
      end
    end

    it 'writes a log `rhel`' do
      expect do
        chef_run.to write_log('rhel').with(
          :level => ':info',
          :message => 'echo "sudo yum -y update" | at now executed'
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

    it 'runs an execute `at apt-get -q update`' do
      expect do
        chef_run.to run_execute('at apt-get -q update').with(
          :command => 'echo "sudo apt-get -q update" | at now'
        )
      end
    end

    it 'writes a log `debian`' do
      expect do
        chef_run.to write_log('debian').with(
          :level => ':info',
          :message => 'echo "sudo apt-get -q update" | at now'
        )
      end
    end
  end
end
