module Fog
  module Vcloud
    module Terremark
      module Vcloud

        module Real

          # Get details of a vdc
          def get_vdc(vdc_uri)
            request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::Vcloud::Terremark::Vcloud::GetVdc.new,
              :uri      => vdc_uri
            )
          end
        end

        module Mock
          #
          #Based off of:
          #https://community.vcloudexpress.terremark.com/en-us/product_docs/w/wiki/09-get-vdc.aspx

          def get_vdc(vdc_uri)
            if vdc = mock_data[:organizations].map { |org| org[:vdcs] }.flatten.detect { |vdc| URI.parse(vdc[:href]) == vdc_uri }
              xml = Builder::XmlMarkup.new
              mock_it Fog::Parsers::Vcloud::Terremark::Vcloud::GetVdc.new, 200,
                xml.Vdc(xmlns.merge(:href => vdc[:href], :name => vdc[:name])) {
                  xml.Link(:rel => "down",
                           :href => vdc[:href] + "/catalog",
                           :type => "application/vnd.vmware.vcloud.catalog+xml",
                           :name => vdc[:name])
                  xml.Link(:rel => "down",
                           :href => vdc[:href] + "/publicIps",
                           :type => "application/xml",
                           :name => "Public IPs")
                  xml.Link(:rel => "down",
                           :href => vdc[:href] + "/internetServices",
                           :type => "application/xml",
                           :name => "Internet Services")
                  xml.ResourceEntities {
                    vdc[:vms].each do |vm|
                      xml.ResourceEntity(:href => vm[:href],
                                         :type => "application/vnd.vmware.vcloud.vApp+xml",
                                         :name => vm[:name])
                    end
                  }
                  xml.AvailableNetworks {
                    vdc[:networks].each do |network|
                      xml.Network(:href => network[:href],
                                  :type => "application/vnd.vmware.vcloud.network+xml",
                                  :name => network[:name])
                    end
                  }
                }, { 'Content-Type' => 'application/vnd.vmware.vcloud.vdc+xml'}
            else
              mock_error 200, "401 Unauthorized"
            end
          end

        end
      end
    end
  end
end
