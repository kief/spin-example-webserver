# encoding: utf-8

title 'application server'

deployment_id = attribute('deployment_id', default: 'unknown', description: 'Which deployment_id to inspect')

describe aws_ec2_instances do
  it { should exist }
  its('states') { should include 'running' }
  its('count') { should eq 1 }
  # TODO: can we say something like 'should_only include'?
  its('image_id') { should include 'ami-63b0341a' }
end

describe aws_ec2_instance(name: "appserver-#{deployment_id}") do
  it { should be_running }
  its('tags') { should include(key: 'DeploymentIdentifier', value: deployment_id) }
  its('tags') { should include(key: 'Component', value: 'simple') }
  its('tags') { should include(key: 'Role', value: 'appserver') }
end
