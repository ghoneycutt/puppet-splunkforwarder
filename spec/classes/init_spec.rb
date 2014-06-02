require 'spec_helper'
describe 'splunkforwarder' do

  context 'with defaults for all parameters' do
    it { should contain_class('splunkforwarder') }
  end
end
