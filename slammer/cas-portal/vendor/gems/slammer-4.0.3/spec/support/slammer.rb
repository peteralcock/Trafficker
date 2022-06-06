require 'active_support/core_ext/object/deep_dup'

RSpec.configure do |config|
  config.before do
    @base_config = Slammer.config.deep_dup
  end

  config.after do
    Slammer.config.clear
    Slammer.config.merge! @base_config
  end
end
