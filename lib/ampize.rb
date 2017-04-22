require 'ampize/version.rb'

require 'ampize'
require 'fastimage'
require 'nokogiri'

module Ampize
  class Ampize
    def initialize(options={})
      default_error_callback = Proc.new do |src|
        %Q|'#{src}' is not found.|
      end
      @options = {
        image_layout: 'responsive',
        image_fetch_error_callback: default_error_callback,
        iframe_layout: 'responsive',
        iframe_sandbox: 'allow-scripts'
      }
      @options.merge!(options)
    end

    def transform(html)
      if html.nil? || html.size == 0
        return ''
      end
      doc = Nokogiri::HTML.parse(html)
      process_prohibited_tags doc
      process_anchor doc
      process_style doc
      process_img doc
      process_iframe doc
      process_event doc
      doc.at('body').children.to_s
    end

    def process_prohibited_tags(doc)
      prohibit_tags = %W|script frame frameset object param applet embed|
      prohibit_tags.each do |ptag|
        doc.search("//#{ptag}").remove
      end
    end

    def process_anchor(doc)
      doc.search('//a[@href]').each do |tag|
          if tag['href'] =~ /javascript/i
              tag.attributes['href'].remove
          end
      end
    end

    def process_style(doc)
      doc.search('//*[@style]').each do |tag|
        tag.attributes['style'].remove
      end
    end

    def process_img(doc)
      doc.search('//img').each do |tag|
        src = tag.attributes['src'].value
        width = tag.attributes['width']
        height = tag.attributes['height']
        if !width || !height
          size = FastImage.size(src)
          if size.nil?
            width = nil
            height = nil
          else
            width = size[0]
            height = size[1]
          end
        else
          width = width.value.to_s
          height = height.value.to_s
        end
        if width && height
          aimg = %Q|<amp-img src="#{src}" width="#{width}" height="#{height}" layout="#{@options[:image_layout]}"></amp-img>|
          tag.replace(aimg)
        else
          tag.replace(@options[:image_fetch_error_callback].call(src))
        end
      end
    end
    
    def process_iframe(doc)
      doc.search('//iframe').each do |tag|
        src = tag.attributes['src'].value
        width = tag.attributes['width']
        height = tag.attributes['height']
        if !width || !height
          width = 400
          height = 300
        else
          width = width.value.to_s
          height = height.value.to_s
        end
        invalid = !(src.index('https') == 0)
        if invalid
          ch = '<div>' + tag.children.to_xml + '</div>'
          tag.replace(ch)
        else
          aiframe = %Q|<amp-iframe src="#{src}" width="#{width}" height="#{height}" layout="#{@options[:iframe_layout]}" sandbox="#{@options[:iframe_sandbox]}"></amp-layout>|
          tag.replace(aiframe)
        end
      end
    end

    def process_event(doc)
      %W|onload onerror onblur onchange onclick ondblclick onfocus
       onkeydown onkeypress onkeyup onmousedown onmouseup onreset
       onselect onsubmit onunload|.each do |attr|
          doc.xpath('//@' + attr).remove
      end
    end

  end
end


