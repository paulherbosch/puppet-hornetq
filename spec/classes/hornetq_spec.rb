#!/usr/bin/env rspec

require 'spec_helper'

describe 'hornetq' do
  it { should contain_class 'hornetq' }
end
