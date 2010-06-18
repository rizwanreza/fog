Shindo.tests('AWS::EC2 | region requests', ['aws']) do

  @regions_format = {
    'regionInfo'  => [{
      'regionEndpoint'  => String,
      'regionName'      => String
    }],
    'requestId'   => String
  }

  tests('success') do

    tests("#describe_regions").formats(@regions_format) do
      AWS[:ec2].describe_regions.body
    end

    tests("#describe_regions('us-east-1')").formats(@regions_format) do
      AWS[:ec2].describe_regions('us-east-1').body
    end

  end

  tests('failure') do

    tests("#describe_regions('us-east-2')").raises(Fog::AWS::EC2::Error) do
      AWS[:ec2].describe_regions('us-east-2')
    end
  end

end
