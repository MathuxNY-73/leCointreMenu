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
require 'locale'
require 'json'

LeCointreURL = 'https://32blanche.lecointreparis.com/LP'

def main(args, logger)
  page = Nokogiri::HTML(open(LeCointreURL))
  element = page.xpath('(//*[@id="tzA2"]//td/text()|//*[@id="tzA2"]//img)')

  items = element.map { |e| e.content.strip }
  menu = []

  _previous = String.new
  items.each_with_index do |e, i|
    if i == 0 or e == ""
      _previous = e
      next
    elsif i == 1
      menu.push('>*%s*:' % e)
    elsif _previous.empty?
      menu.push('\n>*%s*:' % e)
    else
      menu.push(' %s.' % e)
    end
    _previous = e
  end

  menu = menu.join('').strip

  if not menu.include? "Plat Du Chef"
    logger.info("Menu is not available today")
    return
  end


  today_str = DateTime.now.strftime('%A %d %B')

  payload = {
    'username' => 'Menu du jour : ' + today_str,
    'icon_emoji' => ':fork_and_knife:',
    'text' => menu
  }

  uri = URI.parse(args[0]);
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.add_field('Content-Type', 'application/json')
  request.body = payload.to_json
  resp = http.request(request)
  p resp
end

if __FILE__ == $0
  logger = Logger.new(STDOUT);
  main(ARGV, logger)
end
