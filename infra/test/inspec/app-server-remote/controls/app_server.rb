# encoding: utf-8
# copyright: 2018, The Authors

title 'Stuff on the app server'

describe file('/tmp') do
  it { should be_directory }
end
