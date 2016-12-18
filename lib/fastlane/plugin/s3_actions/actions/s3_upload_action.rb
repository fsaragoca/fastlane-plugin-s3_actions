require 's3'

module Fastlane
  module Actions
    class S3UploadAction < Action
      def self.run(params)
        Actions.verify_gem!('s3')

        service = S3::Service.new(access_key_id: params[:access_key_id],
                              secret_access_key: params[:secret_access_key])

        bucket_name = params[:bucket]
        bucket = service.buckets.find(bucket_name)
        if bucket.nil?
          UI.user_error! "Bucket '#{bucket_name}' not found, please verify bucket and credentials 🚫"
        end

        file_name = params[:name] || File.basename(params[:content_path])

        object = bucket.objects.build(file_name)
        object.content = open(params[:content_path])
        object.acl = params[:access_control]

        UI.important("Uploading file to '#{bucket_name}/#{file_name}' 📤")
        object.save
      end

      def self.description
        "Upload a file to AWS S3"
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
          FastlaneCore::ConfigItem.new(key: :access_control,
                                  env_name: "S3_ACTIONS_UPLOAD_ACCESS_CONTROL",
                               description: "File ACL: :public_read or :private",
                                  optional: false,
                             default_value: :private,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :content_path,
                                  env_name: "S3_ACTIONS_UPLOAD_CONTENT_PATH",
                               description: "Path for file to upload",
                                  optional: false,
                                      type: String,
                              verify_block: proc do |value|
                                              if value.nil? || value.empty?
                                                UI.user_error!("No content path for S3_upload action given, pass using `content_path: 'path/to/file.txt'`")
                                              elsif File.file?(value) == false
                                                UI.user_error!("File for path '#{value}' not found")
                                              end
                                            end),
          FastlaneCore::ConfigItem.new(key: :name,
                                  env_name: "S3_ACTIONS_FILE_NAME",
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
