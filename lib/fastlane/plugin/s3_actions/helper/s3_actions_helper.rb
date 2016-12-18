module Fastlane
  module Helper
    class S3ActionsHelper
      # class methods that you define here become available in your action
      # as `Helper::S3ActionsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the s3_actions plugin helper!")
      end
    end
  end
end
