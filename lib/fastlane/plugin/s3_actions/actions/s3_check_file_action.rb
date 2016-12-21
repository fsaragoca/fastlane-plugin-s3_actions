require 's3'

module Fastlane
  module Actions
    class S3CheckFileAction < Action
      def self.run(params)
        Actions.verify_gem!('s3')

        service = S3::Service.new(access_key_id: params[:access_key_id],
                              secret_access_key: params[:secret_access_key])

        bucket_name = params[:bucket]
        file_name = params[:file_name]

        bucket = service.buckets.find(bucket_name)
        if bucket.nil?
          UI.user_error! "Bucket '#{bucket_name}' not found, please verify bucket and credentials 🚫"
        end

        begin
          bucket.objects.find(file_name)
          true
        rescue
          false
        end
      end

      def self.description
        "Check if file exists in AWS S3"
      end

      def self.authors
        ["Fernando Saragoca"]
      end

      def self.return_value
        "Returns 'true' if object exists, 'false' if not"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :access_key_id,
                                  env_name: "S3_ACTIONS_ACCESS_KEY_ID",
                               description: "AWS Access Key",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :secret_access_key,
                                  env_name: "S3_ACTIONS_SECRET_ACCESS_KEY",
                               description: "AWS Secret Access Key",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :bucket,
                                  env_name: "S3_ACTIONS_BUCKET",
                               description: "S3 Bucket",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :file_name,
                                  env_name: "S3_ACTIONS_CHECK_FILE_NAME",
                               description: "File name",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
