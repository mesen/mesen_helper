module MesenHelper
  module Helpers
    module FormHelper
      def conditional_html(options={}, &blk)
        attrs = options.map { |(k, v)| " #{h k}=\"#{h v}\"" }.join('')
        [ "<!--[if lt IE 7 ]>                <html#{attrs} class=\"ie6 no-js oldie\"> <![endif]-->",
          "<!--[if IEMobile 7 ]>             <html#{attrs} class=\"iemob7 no-js oldie\"> <![endif]-->",
          "<!--[if (IE 7) & !(IEMobile 7) ]> <html#{attrs} class=\"ie7 no-js oldie\"> <![endif]-->",
          "<!--[if IE 8 ]>                   <html#{attrs} class=\"ie8 no-js oldie\"> <![endif]-->",
          "<!--[if IE 9 ]>                   <html#{attrs} class=\"ie9 no-js oldie\"> <![endif]-->",
          "<!--[if (gt IE 9)|!(IE)]><!-->    <html#{attrs} class=\"no-js\"> <!--<![endif]-->",
          capture_haml(&blk).strip,
          "</html>"
        ].join("\n")
      end

      def title page_title, options={}
        content_for(:title, page_title.to_s)
      end

      def default_title
        if request.original_fullpath == '/'
          @site.title
        else
          translated_controller_name() << ' – ' << @site.title
        end
      end

      def translated_controller_name
        t controller_name, :scope => 'controllers'
      end

      def relative_or_absolute_date(date)
        if date > Date.today - 2.days
          "for #{time_ago_in_words(date)} siden"
        else
          "#{l date, :format => :short}"
        end
      end

      def clean_body str
        # replace <div> with <p>
        if /<div>/.match(str)
          str.gsub!(/<(\/?)div>/, '<\1p>')
        end

        # replace lines wrapped in <strong> with <h3>
        if /^(\s*)?<strong>(.*)<\/strong>(<br \/>|<\/p>)?(\s*)?$/.match(str)
          str.gsub!(/^(\s*)?<strong>(.*)<\/strong>(<br \/>|<\/p>)?(\s*)?$/, '<h3>\2</h3>\3')
        end

        #replace <p> wrappers around <h3>
        if /<p>(\s*)?(<h3>.*<\/h3>)(\s*)?<\/p>/.match(str)
          str.gsub!(/<p>(\s*)?(<h3>.*<\/h3>)(\s*)?<\/p>/, '\2')
        end

        # another ckeditor stupid thing
        if /<br \/>(\s*)?(<h3>.*<\/h3>)(\s*)?<br \/>/.match(str)
          str.gsub!(/<br \/>(\s*)?(<h3>.*<\/h3>)(\s*)?<br \/>/, '</p>\2<p>')
        end

        # and another one
        if /<p>(\s*)?(<h3>.*<\/h3>)(\s*)?<br \/>$/.match(str)
          str.gsub!(/<p>(\s*)?(<h3>.*<\/h3>)(\s*)?<br \/>$/, '\2<p>')
        end

        # remove empty paragraphs
        if /<p>\s*(&nbsp;)?\s*<\/p>/.match(str)
          str.gsub!(/<p>\s*(&nbsp;)?\s*<\/p>/, '')
        end
        # wrap in paragraphs if none is present
        if str !~/<p>/
          str = simple_format str
        end
        # regular sanitizing
        sanitize str.html_safe, :tags => %w(p img a ul ol li h1 h2 h3 h4 h5 strong b i em br), :attributes => %w(href alt src)
      end

      def clean_paragraph_contents str
        sanitize str.html_safe, :tags => %w(a strong b i em br), :attributes => %w(href alt)
      end

      def menu_item object
        path = article_path(object)
        active = (@article.slug == object.slug) ? true : false
        content_tag(:li, :class => ('active' if active)) do
          content_tag(:a, :href => path) do
            object.title
          end
        end
      end
    end
  end
end
