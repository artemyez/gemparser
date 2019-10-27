class HardWorker
  include Sidekiq::Worker
  require 'open-uri'
  require 'nokogiri'
  require 'json'

  def perform()
    @result = []
    (1..15).each do |page_number|
      url = 'https://rubysec.com/advisories'
      url += "?page=" + page_number.to_s
      html = open(url)
      doc = Nokogiri::HTML(html)
      doc.search('tr').each do |tr|
        cells = tr.search('th, td')
        @result << cells#[1].to_s.gsub(/<\/?[^>]*>/, "").gsub(/\s+/, '')
      end
      @result
    end
    if @result.length != Gemnum.all.last.gemnumber
      Gemnum.create(gemnumber: @result.length)
    else
      p "No new gems"
    end
  end
end
