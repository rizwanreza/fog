module Fog
  module Rackspace
    module Files
      class Real

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_container(name)
          response = storage_request(
            :expects  => [201, 202],
            :method   => 'PUT',
            :path     => CGI.escape(name)
          )
          response
        end

      end

      class Mock

        def put_container(name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
