require 'spec_helper'
describe 'apt_cacher_ng' do
  context 'with default values for all parameters' do
    it { should contain_class('apt_cacher_ng') }
  end
end
