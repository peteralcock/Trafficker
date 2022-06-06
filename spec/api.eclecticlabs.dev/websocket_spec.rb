require 'spec_helper'

# Event Server
describe port(5561) do
  it { should be_listening }
end