#!/usr/bin/env rspec

require 'spec_helper'

describe 'hornetq' do
  let(:params) { { :version => '2.4.0-1.cgk.el6' } }
  it { should contain_class 'hornetq' }
end
