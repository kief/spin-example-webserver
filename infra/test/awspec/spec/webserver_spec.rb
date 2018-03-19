require 'spin_helper'

context "Web Servers in #{deployment_id}" do
  describe ec2_instances_named_in_deployment(deployment_id, "webserver-#{deployment_id}") do
    its(:size) { is_expected.to eq 1 }
    it { is_expected.to all(exist) }
    it { is_expected.to all(be_running) }
  end
end

