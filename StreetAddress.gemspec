# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "street_address"

Gem::Specification.new do |p|
  p.name = 'StreetAddress'
  p.version = StreetAddress::VERSION
  p.authors = ["Derrek Long"]
  p.email = ["derrek.long@gmail.com"]
  p.summary = 'Ruby port of the perl module Geo::StreetAddress::US to parse one line street addresses'
  p.description = "Parses one line addresses and returns a normalized address object.

This is a near direct port of the of the perl module 
Geo::StreetAddress::US originally written by Schuyler D. Erle.  
For more information see
http://search.cpan.org/~sderle/Geo-StreetAddress-US-0.99/"
  p.homepage = "http://streetaddress.rubyforge.org"
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.rubyforge_project = 'streetaddress'
end