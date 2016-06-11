#
# Cookbook Name:: auto-patch
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'auto-patch::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['auto-patch']['prep']['disable'] = true
        node.set['auto-patch']['disable'] = true
      end.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run.to_not raise_error }
    end

    it 'includes the `cron` recipe' do
      expect(chef_run).to include_recipe('cron::default')
    end

    it 'deletes the template `/usr/local/sbin/auto-patch-prep` if node[\'auto-patch\'][\'prep\'][\'disable\'] is true' do
      expect(chef_run).to delete_template('/usr/local/sbin/auto-patch-prep').with(
        :source => 'auto-patch-prep.sh.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0700'
      )
    end

    it 'deletes the cron `auto-patch-prep` if node[\'auto-patch\'][\'prep\'][\'disable\'] is true' do
      expect(chef_run).to delete_cron_d('auto-patch-prep').with(
        #:hour => '',
        #:minute => '',
        #:weekday => '',
        #:day => '',
        #:month => '',
        :command => '/usr/local/sbin/auto-patch-prep'
      )
    end

    it 'deletes the template `/usr/local/sbin/auto-patch` if node[\'auto-patch\'][\'disable\']' do
      expect(chef_run).to delete_template('/usr/local/sbin/auto-patch').with(
        :source => 'auto-patch.sh.erb',
        :owner => 'root',
        :group => 'root',
        :mode => '0700'
      )
    end

    it 'deletes the cron `auto-patch` if node[\'auto-patch\'][\'disable\'] is true' do
      expect(chef_run).to delete_cron_d('auto-patch').with(
        #:hour => '',
        #:minute => '',
        #:weekday => '',
        #:day => '',
        #:month => '',
        :command => '/usr/local/sbin/auto-patch'
      )
    end
  end
end

describe 'auto-patch::default' do
  context 'When `node[\'auto-patch\'][\'now\']` is true, on an unspecified platform' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['auto-patch']['now'] = true
      end.converge(described_recipe)
    end

    it 'includes the `auto-patch::update_now` recipe' do
      expect(chef_run.node['auto-patch']['now']).to eq(true)
      expect(chef_run).to include_recipe('auto-patch::update_now')
    end
  end
end

describe 'auto-patch::default' do
  context 'when `node[\'auto-patch\'][\'once\']` is true, on an unspecified platform' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['auto-patch']['once'] = true
      end.converge(described_recipe)
    end

    it 'includes the `auto-patch::update_once` recipe' do
      expect(chef_run.node['auto-patch']['once']).to eq(true)
      expect(chef_run).to include_recipe('auto-patch::update_once')
    end
  end
end

describe 'auto-patch::default' do
  context 'When all attributes are default, on a `rhel < 6.0` platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'rhel', version: '<6.0')
      runner.converge(described_recipe)
    end

    it 'installs a package `yum-downloadonly' do
      expect { chef_run.to install_package('yum-downloadonly') }
    end
  end
end

describe 'auto-patch::default' do
  context 'When all attributes are default, on a `rhel > 6.0` platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'rhel', version: '>6.0')
      runner.converge(described_recipe)
    end

    it 'installs a package `yum-plugin-downloadonly' do
      expect { chef_run.to install_package('yum-plugin-downloadonly') }
    end
  end
end
