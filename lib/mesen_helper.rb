# encoding: utf-8
require 'mesen_helper/engine' if defined?(::Rails)

module MesenHelper
  extend ActiveSupport::Autoload

  autoload :FormBuilder
  autoload :Helpers
end