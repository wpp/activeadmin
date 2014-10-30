require 'csv'

module ActiveAdmin
  class ResourceController < BaseController

    # This module overrides CSV responses to allow large data downloads.
    # Could be expanded to JSON and XML in the future.
    #
    module Streaming

      def index
        super do |format|
          format.csv { stream_csv }
          yield(format) if block_given?
        end
      end

      protected

      def stream_resource(&block)
        headers['X-Accel-Buffering'] = 'no'
        headers['Cache-Control'] = 'no-cache'

        # To make debugging easier, by default only stream in staging/production
        case Rails.env
        when *ActiveAdmin.application.stream_in
          self.response_body = Enumerator.new &block
        else
          self.response_body = block['']
        end
      end

      def stream_csv
        builder = active_admin_config.csv_builder
        stream_resource &builder.method(:build).to_proc.curry[self]
      end

    end
  end
end
