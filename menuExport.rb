#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

=begin
*************************
* @author: Antoine Pouillaude
* @title: menuExport
* @description: Get the menu from le Cointre and displays it in slack
*************************
=end

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'logger'

LeCointreURL = 'https://32blanche.lecointreparis.com/LP'

def main(args, logger)
  page = Nokogiri::HTML(open(LeCointreURL))
  element = page.xpath('(//*[@id="tzA2"]//td/text()|//*[@id="tzA2"]//img)')

  p element

  args.each do |a|
    p "Argument: #{a}"
  end
end

if __FILE__ == $0
  logger = Logger.new(STDOUT);
  main(ARGV, logger)
end
