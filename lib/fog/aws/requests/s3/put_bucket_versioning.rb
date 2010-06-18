module Fog
  module AWS
    module S3
      class Real

        # Change versioning status for an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to modify
        # * status<~String> - Status to change to in ['Enabled', 'Suspended']
        def put_bucket_versioning(bucket_name, status)
          data =
<<-DATA
<VersioningConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Status>#{status}</Status>
</VersioningConfiguration>
DATA

          request({
            :body     => data,
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :method   => 'PUT',
            :query    => 'versioning'
          })
        end

      end

      class Mock

        def put_bucket_versioning(bucket_name, status)
          raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
