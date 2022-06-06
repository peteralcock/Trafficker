require 'slammer'
require 'slammer/inflections'

module Slammer
  class Engine < Rails::Engine
    isolate_namespace Slammer

    rake_tasks { require 'slammer/tasks' }

    initializer :yaml_configuration do |app|
      apply_yaml_config load_file('config/cas.yml')
    end

    private
    def apply_yaml_config(yaml)
      cfg = (YAML.load(ERB.new(yaml).result)||{}).fetch(Rails.env, {})
      cfg.each do |k,v|
        value = if v.is_a? Hash
          Slammer.config.fetch(k.to_sym,{}).merge(v.symbolize_keys)
        else
          v
        end
        Slammer.config.send("#{k}=", value)
      end
    end

    def load_file(filename)
      fullpath = File.join(Rails.root, filename)
      IO.read(fullpath) rescue ''
    end

  end
end
