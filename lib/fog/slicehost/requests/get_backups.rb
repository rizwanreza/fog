module Fog
  module Slicehost
    class Real

      require 'fog/slicehost/parsers/get_backups'

      # Get list of backups
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'date'<~Time> - Timestamp of backup creation
      #     * 'id'<~Integer> - Id of the backup
      #     * 'name'<~String> - Name of the backup
      #     * 'slice-id'<~Integer> - Id of slice the backup was made from
      def get_backups
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Slicehost::GetBackups.new,
          :path     => 'backups.xml'
        )
      end

    end

    class Mock

      def get_backups
        raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
