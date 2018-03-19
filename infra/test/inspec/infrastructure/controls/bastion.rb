# encoding: utf-8

title 'ssh bastion infrastructure'

deployment_id = attribute('deployment_id', default: 'unknown', description: 'Which deployment_id to inspect')
component = attribute('component', description: 'Which component things should be tagged')

describe aws_ec2_instance(name: "#{component}-#{deployment_id}") do
  it { should be_running }
  its('tags') { should include(key: 'DeploymentIdentifier', value: deployment_id) }
  its('tags') { should include(key: 'Component', value: component) }
end
