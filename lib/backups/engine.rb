module Backups
  class Engine < ::Rails::Engine
    isolate_namespace Backups

    config.backups = ActiveSupport::OrderedOptions.new

    initializer "backups.config" do
      config.backups.each do |name, value|
        Backups.public_send(:"#{name}=", value)
      end
    end
  end
end
