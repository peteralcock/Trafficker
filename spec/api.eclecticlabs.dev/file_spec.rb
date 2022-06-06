require 'spec_helper'

describe file('/etc/kong') do
  it { should be_directory }
end

describe file('/opt/statsd') do
  it { should be_directory }
end

describe file('/etc/apache2') do
  it { should be_directory }
end

describe file('/etc/monit') do
  it { should be_directory }
end

