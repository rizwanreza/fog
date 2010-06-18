module Fog
  module AWS
    module S3
      class Real

        # Get logging status for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get logging status for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'BucketLoggingStatus'<~Hash>: (will be empty if logging is disabled)
        #       * 'LoggingEnabled'<~Hash>:
        #         * 'TargetBucket'<~String> - bucket where logs are stored
        #         * 'TargetPrefix'<~String> - prefix logs are stored with
        #         * 'TargetGrants'<~Array>:
        #           * 'Grant'<~Hash>:
        #             * 'Grantee'<~Hash>:
        #                 * 'DisplayName'<~String> - Display name of grantee
        #                 * 'ID'<~String> - Id of grantee
        #               or
        #                 * 'URI'<~String> - URI of group to grant access for
        #             * 'Permission'<~String> - Permission, in [FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP]
        #
        def get_bucket_logging(bucket_name)
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          request({
            :expects    => 200,
            :headers    => {},
            :host       => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::AWS::S3::GetBucketLogging.new,
            :query      => 'logging'
          })
        end

      end

      class Mock

        def get_bucket_logging(bucket_name)
          raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
