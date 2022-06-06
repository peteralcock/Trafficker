module Slammer
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    # Explicit namespace needed for proper inflection.
    # Thor::Group does not use ActiveSupport's Inflector when programmatically
    # generating the namespace, so this would be to "c_a_sino" otherwise.
    namespace 'slammer:install'

    class_option :migration,
        desc: 'Skip generating migrations',
        type: :boolean,
        default: true

    class_option :config_files,
        desc: 'Install default config files',
        type: :boolean,
        default: true

    def install_migrations
      return unless options['migration']

      rake 'slammer:install:migrations'
    end

    def copy_config_files
      return unless options['config_files']

      copy_file 'cas.yml', 'config/cas.yml'
      copy_file 'slammer_and_overrides.scss', 'app/assets/stylesheets/slammer_and_overrides.scss'
    end

    def insert_assets_loader
      insert_into_file 'app/assets/javascripts/application.js', :after => %r{//= require +['"]?jquery_ujs['"]?} do
        "\n//= require slammer"
      end
    end

    def insert_engine_routes
      route "mount Slammer::Engine => '/', :as => 'slammer'"
    end

    def show_readme
      readme 'README'
    end
  end
end
