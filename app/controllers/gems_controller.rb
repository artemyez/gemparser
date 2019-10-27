class GemsController < ApplicationController
  before_action :find_gems
  require 'open-uri'
  require 'nokogiri'
  require 'json'


  def gem_parser
    #@result = []
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
        #@result << gem_name
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
