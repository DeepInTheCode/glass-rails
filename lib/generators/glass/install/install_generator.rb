require 'generators/glass'
require 'rails/generators'
require 'rails/generators/migration'

module Glass
  module Generators
    class InstallGenerator < Base
      include Rails::Generators::Migration
      argument :user_model, type: :string, default: "User"

      def create_configuration_file
        copy_file("google-oauth.yml", "config/google-api-keys.yml")
      end
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      def create_glass_account_migration
        generate("model", "glass_account token refresh_token expires_at:integer email name #{user_model.underscore.singularize}:references")
        insert_into_file("app/models/#{user_model.underscore.singularize}.rb", "class #{user_model.camelize.singularize}\n", "\s\shas_one :glass_account")
      end
    end
  end
end