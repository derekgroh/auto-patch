name 'auto-patch'
maintainer 'Brian Flad'
maintainer_email 'bflad@417@gmail.com'
license 'Apache 2.0'
description 'Configures node for automatic patching.'
version '0.2.00'
recipe 'auto-patch', 'Configures node for automatic patching.'

%w(cron).each do |d|
  depends d
end

%w(amazon centos debian fedora redhat scientific ubuntu).each do |os|
  supports os
end

issues_url 'https://github.com/derekgroh/auto-patch/issues'
source_url 'https://github.com/derekgroh/auto-patch.git'
