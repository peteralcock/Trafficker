require 'spec_helper'

require 'slammer/authenticator'

describe Slammer::Authenticator do
  subject {
    Slammer::Authenticator.new
  }

  context '#validate' do
    it 'raises an error' do
      expect { subject.validate(nil, nil) }.to raise_error(NotImplementedError)
    end
  end
end
