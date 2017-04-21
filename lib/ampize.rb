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
        image_fetch_error_callback: default_error_callback
      }
      @options.merge!(options)
    end

    def transform(html)
      doc = Nokogiri::HTML.parse(html)
      prohibit_tags = %W|script frame frameset object param applet embed|
      prohibit_tags.each do |ptag|
        doc.search("//#{ptag}").remove
      end
      doc.search('//a[@href]').each do |tag|
          if tag['href'] =~ /javascript/i
              tag.attributes['href'].remove
          end
      end
      doc.search('//*[@style]').each do |tag|
        tag.attributes['style'].remove
      end
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
      %W|onload onerror onblur onchange onclick ondblclick onfocus
       onkeydown onkeypress onkeyup onmousedown onmouseup onreset
       onselect onsubmit onunload|.each do |attr|
          doc.xpath('//@' + attr).remove
      end
      doc.at('body').children.to_s
    end
  end
end


