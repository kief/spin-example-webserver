# encoding: utf-8

title 'application server'

environment = attribute('environment', default: 'unknown', description: 'Which environment to inspect')

describe running_ec2_instances do
  it { should exist }
end

describe aws_ec2_instance(name: "application_server-#{environment}") do
  it { should be_running }
  its('tags') { should include(key: 'Environment', value: environment) }
end
