require "rubygems"
require "nokogiri"
require "open-uri"

class FetchImage
  def initialize
    begin
    rescue ArgumentError => e
      puts e.message
      exit
    end
  end

  def load_fetch_url

  end

  def fetch(url)
    doc = Nokogiri::HTML(open(url))
    doc.css('img').each do |img|
      puts "#{img['src']}, #{img['alt']}, #{img['width']}, #{img['height']}"
    end

  end
end
