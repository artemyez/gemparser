class GemsController < ApplicationController
  before_action :find_gems, :gem_parser
  require 'open-uri'



  def gem_parser
    #@result = []
    @page_nums = []
    @last_page_num
    url = 'https://rubysec.com/advisories'
    html = open(url)
    doc = Nokogiri::HTML(html)
    doc.search('li a').each do |li|
     a = li.to_s.gsub(/<[^>]*>/, "")
     if a.scan(/\D/).empty?
      @page_nums << a
      @last_page_num = @page_nums.last.to_i
     end
    end
    if Gemcheck.all[0] == nil
      (1..@last_page_num).reverse_each do |page_number|
        url = 'https://rubysec.com/advisories'
        url += "?page=" + page_number.to_s
        html = open(url)
        doc = Nokogiri::HTML(html)
        doc.search('tr').reverse_each do |tr|
          cells = tr.search('th, td')
          gem_date = cells[0].to_s.gsub(/<[^>]*>/, "").gsub(/\s+/, '')
          gem_name = cells[1].to_s.gsub(/<[^>]*>/, "").gsub(/\s+/, '')
          gem_title = cells[2].to_s.gsub(/<[^>]*>/, "").gsub(/^\s+/, '')
          gem_cve = cells[3].to_s.gsub(/<[^>]*>/, "").gsub(/\s+/, '')
          Gemcheck.create(date: gem_date, rubygem: gem_name, title: gem_title, cve: gem_cve)
          Gemnum.create(gemnumber: Gemcheck.all.length)
          #@result << gem_name
        end
      end
    end
  end

  def get_last
    (1..15).each do |page_number|
      url = 'https://rubysec.com/advisories'
      url += "?page=" + page_number.to_s
      html = open(url)
      doc = Nokogiri::HTML(html)
      doc.search('tr').each do |tr|
        cells = tr.search('th, td')
        gem_date = cells[0].to_s.gsub(/<[^>]*>/, "").gsub(/\s+/, '')
        gem_name = cells[1].to_s.gsub(/<[^>]*>/, "").gsub(/\s+/, '')
        gem_title = cells[2].to_s.gsub(/<[^>]*>/, "").gsub(/^\s+/, '')
        gem_cve = cells[3].to_s.gsub(/<[^>]*>/, "").gsub(/\s+/, '')
        Gemcheck.create(date: gem_date, rubygem: gem_name, title: gem_title, cve: gem_cve)
        break
      end
      break
    end
  end

  def find_gems
    @gems = Gemcheck.all
    @gems_num = Gemnum.all
  end
end
