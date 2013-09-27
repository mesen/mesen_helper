# encoding: utf-8
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
          if date.year != Date.today.year
            date_format = :long
          else
            date_format = :short
          end
          "#{l date, :format => date_format}"
        end
      end

      def decoder str
        # require 'htmlentities'
        # Replace all &nbsp; with normal spaces, and replace all &aring;, &oslash; and smilar codes with ÆØÅ in the source code
        HTMLEntities.new.decode(str)
      end

      def clean_body2 str

        begin
          str = decoder(str)
        rescue
          puts "Add htmlentities to Gemfile"
        end

         # Add </p><p> behind </strong> if it does not exist
        if /<\/strong>([^<\/p>]+)/.match(str)
          str.gsub!(/<\/strong>([^<\/p>]+)/, '</strong></p><p>\1')
        end
      
        # replace <div> with <p>
        if /<div>/.match(str)
          str.gsub!(/<(\/?)div>/, '<\1p>')
        end

        # replace lines wrapped in <strong> with <h3>
        if /^(\s*)?<strong>(.*)<\/strong>(<br \/>|<\/p>)?(\s*)?$/.match(str)
          str.gsub!(/^(\s*)?<strong>(.*)<\/strong>(<br \/>|<\/p>)?(\s*)?$/, '<h3>\2</h3>\3')
        end

        if /<strong>(.*)<\/strong>/.match(str)
          str.gsub!(/<strong>(.*)<\/strong>/, '<h3>\1</h3>')
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

        # wrap in paragraphs if none is present
        if str !~/<p>/
          str = simple_format str
        end

        # remove empty paragraphs
        if /<p>\s*(&nbsp;)?\s*<\/p>/.match(str)
          str.gsub!(/<p>\s*(&nbsp;)?\s*<\/p>/, '<br>')
        end

        if /<p><div>&nbsp;<\/div>\s?<\/p>/.match(str)
          str.gsub!(/<p><div>&nbsp;<\/div>\s?<\/p>/, '<span> </span>')
        end


        # Delete breaks in list
        if /<br \/>\s*?<li>/.match(str)
          str.gsub!(/<br \/>\s*?<li>/, '<li>')
        end

        # regular sanitizing
        sanitize str.html_safe, :tags => %w(p img a ul ol li h1 h2 h3 h4 h5 strong b i em br blockquote), :attributes => %w(href alt src style)
      end

      def clean_body str
        # replace <div> with <p>
        if /<div>/.match(str)
          str.gsub!(/<(\/?)div>/, '<\1p>')
        end

        # Add several strongs behind to one strong
        puts "_______________________________"
        while /(\s*)?<\/strong>(\s*)?<strong>/.match(str)
          puts "DRIN"
          str.gsub!(/(\s*)?<\/strong>(\s*)?<strong>/,'')
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
        sanitize str.html_safe, :tags => %w(p img a ul ol li h1 h2 h3 h4 h5 strong b i em br), :attributes => %w(href alt src style)
      end

      def clean_paragraph_contents str
        sanitize str.html_safe, :tags => %w(a strong b i em br), :attributes => %w(href alt)
      end
    end
  end
end
