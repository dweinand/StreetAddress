# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/street_address.rb'

Hoe.new('StreetAddress', StreetAddress::VERSION) do |p|
  p.rubyforge_name = 'streetaddress'
  p.summary = 'Ruby port of the perl module Geo::StreetAddress::US to parse one line street addresses'
  p.description = "Parses one line addresses and returns a normalized address object.

This is a near direct port of the of the perl module 
Geo::StreetAddress::US originally written by Schuyler D. Erle.  
For more information see
http://search.cpan.org/~sderle/Geo-StreetAddress-US-0.99/"
  p.url = "http://streetaddress.rubyforge.org"
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.author = "Derrek Long"
  p.email = "derrek.long@gmail.com"
end

# vim: syntax=Ruby
