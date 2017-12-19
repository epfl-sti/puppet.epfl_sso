require 'spec_helper'
describe 'ntp' do
  context 'with default values for all parameters' do
    it { should contain_class('ntp') }
  end
end
