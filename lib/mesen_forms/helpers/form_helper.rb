module MesenForms
  module Helpers
    module FormHelper
      def mesen_form_for (object, options = {}, &block)
        options[:builder] = FormBuilder #MesenFormBuilder
        options[:url]     = { :action => object.id.nil? ? "create" : "update"}
        options[:html]    = {:class => 'form-horizontal'}
        form_for(object, options, &block)
      end
    end
  end
end
