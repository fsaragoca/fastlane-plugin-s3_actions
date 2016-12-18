require 's3'

module Fastlane
  module Actions
    class S3DownloadAction < Action
      def self.run(params)
        Actions.verify_gem!('s3')

        service = S3::Service.new(access_key_id: params[:access_key_id],
                              secret_access_key: params[:secret_access_key])

        bucket_name = params[:bucket]
        file_name = params[:file_name]
        output_path = params[:output_path]

        output_directory = File.dirname(output_path)
        unless File.exists?(output_directory)
          Actions.sh("mkdir #{output_directory}", log: $verbose)
        end

        bucket = service.buckets.find(bucket_name)
        if bucket.nil?
          UI.user_error! "Bucket '#{bucket_name}' not found, please verify bucket and credentials 🚫"
        end

        begin
          object = bucket.objects.find(file_name)
        rescue
          UI.user_error! "Object '#{file_name}' not found, please verify file and bucket 🚫"
        end

        UI.important("Downloading file '#{bucket_name}/#{file_name}' 📥")
        File.write(output_path, object.content)
      end

      def self.description
        "Download a file from AWS S3"
      end

      def self.authors
        ["Fernando Saragoca"]
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
          FastlaneCore::ConfigItem.new(key: :output_path,
                                  env_name: "S3_ACTIONS_OUTPUT_PATH",
                               description: "Path to save downloaded file",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :file_name,
                                  env_name: "S3_ACTIONS_DOWNLOAD_FILE_NAME",
                               description: "File name",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
