# Expect all patches to be applied
case os[:family]
when 'centos'
  describe bash('yum -y update') do
    its('stderr') { should eq '' }
    its(:exit_status) { should eq 0 }
  end
when 'ubuntu'
  describe bash('apt-get -q update') do
    its('stderr') { should eq '' }
    its(:exit_status) { should eq 0 }
  end
end
