module Fog
  module AWS
    module EC2
      class Real

        # Describe all or specified regions
        #
        # ==== Params
        # * region_name<~String> - List of regions to describe, defaults to all
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'regionInfo'<~Array>:
        #       * 'regionName'<~String> - Name of region
        #       * 'regionEndpoint'<~String> - Service endpoint for region
        def describe_regions(region_name = [])
          params = AWS.indexed_param('RegionName', region_name)
          request({
            'Action'    => 'DescribeRegions',
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::EC2::DescribeRegions.new
          }.merge!(params))
        end

      end

      class Mock

        def describe_regions(region_name = [])
          response = Excon::Response.new
          region_name = [*region_name]
          regions = {
            'eu-west-1' => {"regionName"=>"eu-west-1", "regionEndpoint"=>"eu-west-1.ec2.amazonaws.com"},
            'us-east-1' => {"regionName"=>"us-east-1", "regionEndpoint"=>"us-east-1.ec2.amazonaws.com"}
          }
          if region_name != []
            region_info = regions.reject {|key, value| !region_name.include?(key)}.values
          else
            region_info = regions.values
          end

          if region_name.length == 0 || region_name.length == region_info.length
            response.status = 200
            response.body = {
              'requestId'   => Fog::AWS::Mock.request_id,
              'regionInfo'  => region_info
            }
          else
            response.status = 400
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
