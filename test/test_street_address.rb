require 'test/unit'
require File.dirname(__FILE__) + '/../lib/street_address'


class TestStreetAddressUs < Test::Unit::TestCase
  
  def test_should_not_parse_junk
    assert_nil StreetAddress::US.parse("&")
    assert_nil StreetAddress::US.parse(" and ")
  end
  
  def test_should_parse_apt
    address = "2730 S Veitch St Apt 207, Arlington, VA 22206"
    addr = StreetAddress::US.parse(address)
    assert_equal "2730",      addr.number
    assert_equal "22206",     addr.postal_code
    assert_equal "S",         addr.prefix
    assert_equal "VA",        addr.state
    assert_equal "Veitch",    addr.street
    assert_equal "St",        addr.street_type
    assert_equal "207",       addr.unit
    assert_equal "Apt",       addr.unit_prefix
    assert_equal "Arlington", addr.city
    assert_equal nil,         addr.prefix2
    assert_equal nil,         addr.postal_code_ext
  end
  
  def test_should_parse_unit_num
    address = "2730 S Veitch St #207, Arlington, VA 22206"
    addr = StreetAddress::US.parse(address)
    assert_equal "207",       addr.unit
  end
  
  def test_should_parse_suite
    address = "44 Canal Center Plaza Suite 500, Alexandria, VA 22314"
    addr = StreetAddress::US.parse(address)
    assert_equal "44",           addr.number
    assert_equal "22314",        addr.postal_code
    assert_equal nil,            addr.prefix
    assert_equal "VA",           addr.state
    assert_equal "Canal Center", addr.street
    assert_equal "Plz",          addr.street_type
    assert_equal "500",          addr.unit
    assert_equal "Suite",        addr.unit_prefix
    assert_equal "Alexandria",   addr.city
    assert_equal nil,            addr.street2
  end
  
  def test_should_parse_white_house
    address = "1600 Pennsylvania Ave Washington DC"
    addr = StreetAddress::US.parse(address)
    assert_equal "1600",         addr.number
    assert_equal nil,            addr.postal_code
    assert_equal nil,            addr.prefix
    assert_equal "DC",           addr.state
    assert_equal "Pennsylvania", addr.street
    assert_equal "Ave",          addr.street_type
    assert_equal nil,            addr.unit
    assert_equal nil,            addr.unit_prefix
    assert_equal "Washington",   addr.city
    assert_equal nil,            addr.street2
  end
  
  def test_should_parse_highway
    address = "1005 Gravenstein Hwy N, Sebastopol CA 95472"
    addr = StreetAddress::US.parse(address)
    assert_equal "1005",        addr.number
    assert_equal "95472",       addr.postal_code
    assert_equal nil,           addr.prefix
    assert_equal "CA",          addr.state
    assert_equal "Gravenstein", addr.street
    assert_equal "Hwy",         addr.street_type
    assert_equal nil,           addr.unit
    assert_equal nil,           addr.unit_prefix
    assert_equal "Sebastopol",  addr.city
    assert_equal nil,           addr.street2
    assert_equal "N",           addr.suffix
  end
  
  def test_should_not_parse_po_box
    address = "PO BOX 450, Chicago IL 60657"
    addr = StreetAddress::US.parse(@addr5)
    assert_nil addr
  end
  
  def test_should_parse_intersection
    intersection = "Hollywood & Vine, Los Angeles, CA"
    addr = StreetAddress::US.parse(intersection)
    assert_equal "Los Angeles", addr.city
    assert_equal "CA",          addr.state
    assert_equal "Hollywood",   addr.street
    assert_equal "Vine",        addr.street2
    assert_equal nil,           addr.number
    assert_equal nil,           addr.postal_code
    assert_equal true,          addr.intersection?
  end
  
  def test_should_parse_la_intersection
    intersection = "Hollywood Blvd and Vine St, Los Angeles, CA"
    addr = StreetAddress::US.parse(intersection)
    assert_equal "Los Angeles", addr.city
    assert_equal "CA",          addr.state
    assert_equal "Hollywood",   addr.street
    assert_equal "Vine",        addr.street2
    assert_equal nil,           addr.number
    assert_equal nil,           addr.postal_code
    assert_equal true,          addr.intersection?
    assert_equal "Blvd",        addr.street_type
    assert_equal "St",          addr.street_type2
  end
  
  def test_should_parse_sf_intersection
    intersection = "Mission Street at Valencia Street, San Francisco, CA"
    addr = StreetAddress::US.parse(intersection)
    assert_equal "San Francisco", addr.city
    assert_equal "CA",            addr.state
    assert_equal "Mission",       addr.street
    assert_equal "Valencia",      addr.street2
    assert_equal nil,             addr.number
    assert_equal nil,             addr.postal_code
    assert_equal true,            addr.intersection?
    assert_equal "St",            addr.street_type
    assert_equal "St",            addr.street_type2 
  end
  
  def test_parse
    parseable = ["1600 Pennsylvania Ave Washington DC 20006", 
          "1600 Pennsylvania Ave #400, Washington, DC, 20006",
          "1600 Pennsylvania Ave Washington, DC",
          "1600 Pennsylvania Ave #400 Washington DC",
          "1600 Pennsylvania Ave, 20006",
          "1600 Pennsylvania Ave #400, 20006",
          "1600 Pennsylvania Ave 20006",
          "1600 Pennsylvania Ave #400 20006",
          "Hollywood & Vine, Los Angeles, CA",
          "Hollywood Blvd and Vine St, Los Angeles, CA",
          "Mission Street at Valencia Street, San Francisco, CA",
          "Hollywood & Vine, Los Angeles, CA, 90028",
          "Hollywood Blvd and Vine St, Los Angeles, CA, 90028",
          "Mission Street at Valencia Street, San Francisco, CA, 90028"]
    
    parseable.each do |location|
      assert_not_nil(StreetAddress::US.parse(location), location + " was not parse able")
    end

  end
  
  def test_should_parse_ordinals
    address = "701 First Avenue, Minneapolis, MN 55403"
    addr    = StreetAddress::US.parse(address)
    assert_equal '1st', addr.street
    assert_equal 'Ave', addr.street_type
  end
  
  def test_should_parse_ordinals_on_intersection
    address = "First Avenue and Seventh Street, Minneapolis, MN 55403"
    addr    = StreetAddress::US.parse(address)
    assert_equal '7th', addr.street2
    assert_equal 'St', addr.street_type2
    assert_equal '1st', addr.street
    assert_equal 'Ave', addr.street_type
  end
  
  def test_should_have_street_address
    address = "701 First Avenue, Minneapolis, MN 55403"
    addr    = StreetAddress::US.parse(address)
    assert_equal '1st Ave', addr.street_address
  end
  
  def test_should_have_house_address
    address = "701 First Avenue, Minneapolis, MN 55403"
    addr    = StreetAddress::US.parse(address)
    assert_equal '701 1st Ave', addr.house_address
  end
  
  def test_should_have_house_number_for_suite
    address = "44 Canal Center Plaza Suite 500, Alexandria, VA 22314"
    addr = StreetAddress::US.parse(address)
    assert_equal '44 Canal Center Plz Suite 500', addr.house_address
  end
  
  def test_should_have_street_addresses_on_intersection
    address = "First Avenue and Seventh Street, Minneapolis, MN 55403"
    addr    = StreetAddress::US.parse(address)
    assert_equal "1st Ave", addr.street_address
    assert_equal "7th St", addr.street_address2
  end
  
  def test_should_have_to_s
    address = "701 First Avenue, Minneapolis, MN 55403"
    addr    = StreetAddress::US.parse(address)
    assert_equal '701 1st Ave, Minneapolis, MN 55403', addr.to_s
  end
  
  def test_should_have_to_s_on_intersection
    address = "First Avenue and Seventh Street, Minneapolis, MN 55403"
    addr    = StreetAddress::US.parse(address)
    assert_equal "1st Ave and 7th St, Minneapolis, MN 55403", addr.to_s
  end
  
end
