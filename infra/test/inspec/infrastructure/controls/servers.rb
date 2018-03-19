# encoding: utf-8

title 'servers'

deployment_id = attribute('deployment_id', default: 'unknown', description: 'Which deployment_id to inspect')
component = attribute('component', description: 'Which component things should be tagged')
role = attribute('role', description: 'Which role things should be tagged')

describe aws_ec2_instances(state_name: 'running',
      tag_value: "DeploymentIdentifier:#{deployment_id}" ) do
  it { should have_instances }
  its('count') { should eq 2 }
  # TODO: can we say something like 'should_only include'?
  its('image_id') { should include 'ami-63b0341a' }
  its('name') { should include "#{role}-#{deployment_id}" }
  its('name') { should include "#{component}-#{deployment_id}" }
  # Redundant, but flags if I've botched the aws_ec2_instances code
  its('states') { should include 'running' }
end
