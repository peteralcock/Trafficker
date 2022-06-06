require 'spec_helper'

# describe package('monit')  do
#   it { should be_installed }
# end

describe package('apache2') do
  it { should be_installed }
end

#describe package('pushpin') do
#  it { should be_installed }
#end

describe package('ntp') do
  it { should be_installed }
end

describe package('memcached') do
  it { should be_installed }
end

describe package('eclecticLabs.collectd') do
  it { should be_installed }
end

describe package('curl') do
  it { should be_installed }
end