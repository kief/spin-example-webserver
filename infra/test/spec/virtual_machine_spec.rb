require 'spin_helper'

context "Application Servers in #{environment_name}" do
  describe named_ec2_instances_in_env(environment_name, 'application_server') do
    it { should have(1).items }
    it { is_expected.to all(exist) }
    it { is_expected.to all(be_running) }
  end
end

