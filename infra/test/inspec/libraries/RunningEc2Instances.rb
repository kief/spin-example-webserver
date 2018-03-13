class RunningEc2Instances < Inspec.resource(1)
  name 'running_ec2_instances'
  desc 'Verifies settings for a list of ec2 instances'
  example "
    describe running_ec2_instances.where(thing: 'thing') do
      it { should exist }
      its('states') { should include 'running' }
      its('count') { should eq 1 }
    end
  "

  supports platform: 'aws'

  include AwsPluralResourceMixin

  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:count) { |x| x.entries.length }
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:state_array, field: :state)
        .add(:states) { |x| x.entries.map { |e| e.state[:name] } }
  filter.connect(self, :table)

  def validate_params(resource_params)
    unless resource_params.empty?
      raise ArgumentError, 'running_ec2_instances does not accept resource parameters.'
    end
    resource_params
  end

  def to_s
    'List of EC2 Instances'
  end

  def fetch_from_api
    runner = BackendFactory.create(inspec_runner)
    instances = runner.describe_ec2_instances[:reservations].first.instances
    @table = instances.map(&:to_h)
  end

  class Backend
    class AwsClientApi < AwsBackendBase
      BackendFactory.set_default_backend(self)
      self.aws_client_class = Aws::EC2::Client

      def describe_ec2_instances(query = {})
        aws_service_client.describe_instances(query)
      end
    end
  end

end
