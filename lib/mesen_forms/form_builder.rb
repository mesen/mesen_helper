module MesenForms
  class FormBuilder < ::ActionView::Helpers::FormBuilder
    
    %w[text_area text_field password_field collection_select].each do |method_name|
      define_method(method_name) do |attribute, *options|
        opts = options.extract_options!
        if opts[:skip_label]
          super(attribute, *options)
        else
          control_group do
            label(attribute, class: 'control-label')+
            controls do
              super(attribute, *options)+
              if opts[:help]
                help_block opts[:help]
              end
            end
          end
        end
      end
    end

    def errors object
      if object.errors.any?
        content_tag :div, :class => 'alert span7 alert-error' do
          content_tag(:a, "&times;".html_safe, href: "#", class: "close", data: {dismiss: "alert"})+
          content_tag(:h3, I18n.t('activerecord.errors.template.header', :count => object.errors.size, :model => I18n.t(object.class.to_s.underscore, :scope => [:activerecord, :models])))+
          content_tag(:ul) do
            object.errors.full_messages.reduce('') { |ccc, message| ccc << content_tag(:li, message) }.html_safe
          end
        end
      end
    end

    def image_upload(attribute, options={})
      control_group do
        label(attribute, class: 'control-label')+
        controls do
          if(defined?object[attribute] && !object[attribute].blank?)
            # ::TODO:: make this into a real variable!!! (use attribute instead of the hard-coded 'background_image')
            @template.image_tag(object.background_image.url(:thumb))
          end+
          tag('br')+
          file_field(attribute)+
          if options[:help]
            help_block options[:help]
          end
        end
      end
    end

    def datetime_select(attribute, options={})
      control_group do
        label(attribute, class: 'control-label')+
        controls do
          super+
          if options[:help]
            help_block options[:help]
          end
        end
      end
    end

    def map_input(attribute, options={})
      control_group do
        label(attribute, class: 'control-label')+
        controls do
          hidden_field(:lat).html_safe+
          hidden_field(:lng).html_safe
        end
      end
    end

    def control_group
      content_tag(:div, class: 'control-group') do
        yield
      end
    end

    def controls options={}
      content_tag :div, class: 'controls' do
        yield
      end
    end

    def help_block string
      content_tag :p, class: 'help-block' do
        I18n.t string, :scope => [:activerecord, :help_strings, @template.controller_name.singularize]
      end
    end
  end
end
