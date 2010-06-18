require 'fog/collection'
require 'fog/rackspace/models/servers/image'

module Fog
  module Rackspace
    module Servers

      class Real
        def images(attributes = {})
          Fog::Rackspace::Servers::Images.new({
            :connection => self
          }.merge!(attributes))
        end
      end

      class Mock
        def images(attributes = {})
          Fog::Rackspace::Servers::Images.new({
            :connection => self
          }.merge!(attributes))
        end
      end

      class Images < Fog::Collection

        model Fog::Rackspace::Servers::Image

        attribute :server

        def all
          data = connection.list_images_detail.body['images']
          load(data)
          if server
            self.replace(self.select {|image| image.server_id == server.id})
          end
        end

        def get(image_id)
          data = connection.get_image_details(image_id).body['image']
          new(data)
        rescue Fog::Rackspace::Servers::NotFound
          nil
        end

      end

    end
  end
end
