module Fog
  module AWS
    module EC2

      class Error < Fog::Error; end

      def self.new(options={})

        unless @required
          require 'fog/aws/models/ec2/address'
          require 'fog/aws/models/ec2/addresses'
          require 'fog/aws/models/ec2/flavor'
          require 'fog/aws/models/ec2/flavors'
          require 'fog/aws/models/ec2/image'
          require 'fog/aws/models/ec2/images'
          require 'fog/aws/models/ec2/key_pair'
          require 'fog/aws/models/ec2/key_pairs'
          require 'fog/aws/models/ec2/security_group'
          require 'fog/aws/models/ec2/security_groups'
          require 'fog/aws/models/ec2/server'
          require 'fog/aws/models/ec2/servers'
          require 'fog/aws/models/ec2/snapshot'
          require 'fog/aws/models/ec2/snapshots'
          require 'fog/aws/models/ec2/volume'
          require 'fog/aws/models/ec2/volumes'
          require 'fog/aws/parsers/ec2/allocate_address'
          require 'fog/aws/parsers/ec2/attach_volume'
          require 'fog/aws/parsers/ec2/basic'
          require 'fog/aws/parsers/ec2/create_key_pair'
          require 'fog/aws/parsers/ec2/create_snapshot'
          require 'fog/aws/parsers/ec2/create_volume'
          require 'fog/aws/parsers/ec2/describe_addresses'
          require 'fog/aws/parsers/ec2/describe_availability_zones'
          require 'fog/aws/parsers/ec2/describe_images'
          require 'fog/aws/parsers/ec2/describe_instances'
          require 'fog/aws/parsers/ec2/describe_key_pairs'
          require 'fog/aws/parsers/ec2/describe_regions'
          require 'fog/aws/parsers/ec2/describe_reserved_instances'
          require 'fog/aws/parsers/ec2/describe_security_groups'
          require 'fog/aws/parsers/ec2/describe_snapshots'
          require 'fog/aws/parsers/ec2/describe_volumes'
          require 'fog/aws/parsers/ec2/detach_volume'
          require 'fog/aws/parsers/ec2/get_console_output'
          require 'fog/aws/parsers/ec2/run_instances'
          require 'fog/aws/parsers/ec2/terminate_instances'
          require 'fog/aws/requests/ec2/allocate_address'
          require 'fog/aws/requests/ec2/associate_address'
          require 'fog/aws/requests/ec2/attach_volume'
          require 'fog/aws/requests/ec2/authorize_security_group_ingress'
          require 'fog/aws/requests/ec2/create_key_pair'
          require 'fog/aws/requests/ec2/create_security_group'
          require 'fog/aws/requests/ec2/create_snapshot'
          require 'fog/aws/requests/ec2/create_volume'
          require 'fog/aws/requests/ec2/delete_key_pair'
          require 'fog/aws/requests/ec2/delete_security_group'
          require 'fog/aws/requests/ec2/delete_snapshot'
          require 'fog/aws/requests/ec2/delete_volume'
          require 'fog/aws/requests/ec2/describe_addresses'
          require 'fog/aws/requests/ec2/describe_availability_zones'
          require 'fog/aws/requests/ec2/describe_images'
          require 'fog/aws/requests/ec2/describe_instances'
          require 'fog/aws/requests/ec2/describe_reserved_instances'
          require 'fog/aws/requests/ec2/describe_key_pairs'
          require 'fog/aws/requests/ec2/describe_regions'
          require 'fog/aws/requests/ec2/describe_security_groups'
          require 'fog/aws/requests/ec2/describe_snapshots'
          require 'fog/aws/requests/ec2/describe_volumes'
          require 'fog/aws/requests/ec2/detach_volume'
          require 'fog/aws/requests/ec2/disassociate_address'
          require 'fog/aws/requests/ec2/get_console_output'
          require 'fog/aws/requests/ec2/modify_image_attributes'
          require 'fog/aws/requests/ec2/reboot_instances'
          require 'fog/aws/requests/ec2/release_address'
          require 'fog/aws/requests/ec2/revoke_security_group_ingress'
          require 'fog/aws/requests/ec2/run_instances'
          require 'fog/aws/requests/ec2/terminate_instances'
          @required = true
        end

        unless options[:aws_access_key_id]
          raise ArgumentError.new('aws_access_key_id is required to access ec2')
        end
        unless options[:aws_secret_access_key]
          raise ArgumentError.new('aws_secret_access_key is required to access ec2')
        end
        if Fog.mocking?
          Fog::AWS::EC2::Mock.new(options)
        else
          Fog::AWS::EC2::Real.new(options)
        end
      end

      def self.reset_data(keys=Mock.data.keys)
        Mock.reset_data(keys)
      end

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            owner_id = Fog::AWS::Mock.owner_id
            hash[key] = {
              :deleted_at => {},
              :addresses  => {},
              :instances  => {},
              :key_pairs  => {},
              :limits     => { :addresses => 5 },
              :owner_id   => owner_id,
              :security_groups => {
                'default' => {
                  'groupDescription'  => 'default group',
                  'groupName'         => 'default',
                  'ipPermissions'     => [
                    {
                      'groups'      => [{'groupName' => 'default', 'userId' => owner_id}],
                      'fromPort'    => -1,
                      'toPort'      => -1,
                      'ipProtocol'  => 'icmp',
                      'ipRanges'    => []
                    },
                    {
                      'groups'      => [{'groupName' => 'default', 'userId' => owner_id}],
                      'fromPort'    => 0,
                      'toPort'      => 65535,
                      'ipProtocol'  => 'tcp',
                      'ipRanges'    => []
                    },
                    {
                      'groups'      => [{'groupName' => 'default', 'userId' => owner_id}],
                      'fromPort'    => 0,
                      'toPort'      => 65535,
                      'ipProtocol'  => 'udp',
                      'ipRanges'    => []
                    }
                  ],
                  'ownerId'           => owner_id
                }
              },
              :snapshots => {},
              :volumes => {}
            }
          end
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @aws_access_key_id = options[:aws_access_key_id]
          @data = self.class.data[@aws_access_key_id]
          @owner_id = @data[:owner_id]
        end

      end

      class Real

        # Initialize connection to EC2
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and 
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   sdb = SimpleDB.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use, in ['eu-west-1', 'us-east-1', 'us-west-1']
        #
        # ==== Returns
        # * EC2 object with connection to aws.
        def initialize(options={})
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @hmac = HMAC::SHA256.new(@aws_secret_access_key)
          @host = options[:host] || case options[:region]
            when 'ap-southeast-1'
              'ec2.ap-southeast-1.amazonaws.com'
            when 'eu-west-1'
              'ec2.eu-west-1.amazonaws.com'
            when 'us-east-1'
              'ec2.us-east-1.amazonaws.com'
            when 'us-west-1'
              'ec2.us-west-1.amazonaws.com'
            else
              'ec2.amazonaws.com'
            end
          @port       = options[:port]      || 443
          @scheme     = options[:scheme]    || 'https'
        end

        private

        def request(params)
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")

          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :hmac               => @hmac,
              :host               => @host,
              :version            => '2009-11-30'
            }
          )

          begin
            response = @connection.request({
              :body       => body,
              :expects    => 200,
              :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
              :idempotent => idempotent,
              :host       => @host,
              :method     => 'POST',
              :parser     => parser
            })
          rescue Excon::Errors::Error => error
            if match = error.message.match(/<Code>(.*)<\/Code><Message>(.*)<\/Message>/)
              new_error = Fog::AWS::EC2::Error.new("#{match[1]} => #{match[2]}")
              new_error.set_backtrace(error.backtrace)
              raise new_error
            else
              raise error
            end
          end

          response
        end

      end
    end
  end
end
