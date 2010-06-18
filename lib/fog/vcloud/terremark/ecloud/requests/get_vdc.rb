module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real

          # Get details of a vdc
          def get_vdc(vdc_uri)
            request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::Parsers::Vcloud::Terremark::Ecloud::GetVdc.new,
              :uri      => vdc_uri
            )
          end
        end

        module Mock
          #
          #Based off of:
          #http://support.theenterprisecloud.com/kb/default.asp?id=545&Lang=1&SID=

          def get_vdc(vdc_uri)
            if vdc = mock_data[:organizations].map { |org| org[:vdcs] }.flatten.detect { |vdc| URI.parse(vdc[:href]) == vdc_uri }
              xml = Builder::XmlMarkup.new
              mock_it Fog::Parsers::Vcloud::Terremark::Ecloud::GetVdc.new, 200,
                xml.Vdc(xmlns.merge(:href => vdc[:href], :name => vdc[:name])) {
                  xml.Link(:rel => "down",
                           :href => vdc[:href] + "/catalog",
                           :type => "application/vnd.vmware.vcloud.catalog+xml",
                           :name => vdc[:name])
                  xml.Link(:rel => "down",
                           :href => vdc[:href].gsub('/vdc','/extensions/vdc') + "/publicIps",
                           :type => "application/vnd.tmrk.ecloud.publicIpsList+xml",
                           :name => "Public IPs")
                  xml.Link(:rel => "down",
                           :href => vdc[:href] + "/internetServices",
                           :type => "application/vnd.tmrk.ecloud.internetServicesList+xml",
                           :name => "Internet Services")
                  xml.Link(:rel => "down",
                           :href => vdc[:href].sub('/vdc','/extensions/vdc') + "/firewallAcls",
                           :type => "application/vnd.tmrk.ecloud.firewallAclsList+xml",
                           :name => "Firewall Access List")
                  xml.Description("")
                  xml.StorageCapacity {
                    xml.Units("bytes * 10^9")
                    xml.Allocated(vdc[:storage][:allocated])
                    xml.Used(vdc[:storage][:used])
                  }
                  xml.ComputeCapacity {
                    xml.Cpu {
                      xml.Units("hz * 10^6")
                      xml.Allocated(vdc[:cpu][:allocated])
                    }
                    xml.Memory {
                      xml.Units("bytes * 2^20")
                      xml.Allocated(vdc[:memory][:allocated])
                    }
                    xml.DeployedVmsQuota {
                      xml.Limit("-1")
                      xml.Used("-1")
                    }
                    xml.InstantiatedVmsQuota {
                      xml.Limit("-1")
                      xml.Used("-1")
                    }
                  }
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

