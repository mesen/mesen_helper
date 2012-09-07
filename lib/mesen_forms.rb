# encoding: utf-8
require 'mesen_forms/engine' if defined?(::Rails)

module MesenForms
  extend ActiveSupport::Autoload

  autoload :FormBuilder
  autoload :Helpers
end