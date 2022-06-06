require 'spec_helper'

describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

# Process Monitor
# describe service('monit') do
#   it { should be_enabled }
#   it { should be_running }
# end


# Graphite Web UI
describe port(8081) do
  it { should be_listening }
end

# PostgreSQL Database
describe port(5432) do
  it { should be_listening }
end

# Analytic Dashboard
describe port(3030) do
  it { should be_listening }
end

# API Admin Endpoint
describe port(8001) do
  it { should be_listening }
end

# API Service Endpoint
describe port(8000) do
  it { should be_listening }
end

# Trafficker UI
describe port(8080) do
  it { should be_listening }
end

# Event Server
describe port(5561) do
  it { should be_listening }
end