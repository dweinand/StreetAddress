=begin rdoc

=== Usage:
    StreetAddress::US.parse("1600 Pennsylvania Ave, washington, dc")

=== Valid Address Formats

    1600 Pennsylvania Ave Washington DC 20006
    1600 Pennsylvania Ave #400, Washington, DC, 20006
    1600 Pennsylvania Ave Washington, DC
    1600 Pennsylvania Ave #400 Washington DC
    1600 Pennsylvania Ave, 20006
    1600 Pennsylvania Ave #400, 20006
    1600 Pennsylvania Ave 20006
    1600 Pennsylvania Ave #400 20006

=== Valid Intersection Formats

    Hollywood & Vine, Los Angeles, CA
    Hollywood Blvd and Vine St, Los Angeles, CA
    Mission Street at Valencia Street, San Francisco, CA
    Hollywood & Vine, Los Angeles, CA, 90028
    Hollywood Blvd and Vine St, Los Angeles, CA, 90028
    Mission Street at Valencia Street, San Francisco, CA, 90028
    
==== License

    Copyright (c) 2007 Riderway (Derrek Long, Nicholas Schlueter)

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

==== Notes
    If parts of the address are omitted from the original string 
    the accessor will be nil in StreetAddress::US::Address.
    
    Example:
    address = StreetAddress::US.parse("1600 Pennsylvania Ave, washington, dc")
    assert address.postal_code.nil?
    
==== Acknowledgements
    
    This gem is a near direct port of the perl module Geo::StreetAddress::US
    originally written by Schuyler D. Erle.  For more information see
    http://search.cpan.org/~sderle/Geo-StreetAddress-US-0.99/
    
=end

module StreetAddress
  VERSION = '1.0.1'
  class US
    @@directional = {
      "north" => "N",
      "northeast" => "NE",
      "east" => "E",
      "southeast" => "SE",
      "south" => "S",
      "southwest" => "SW",
      "west" => "W",
      "northwest" => "NW"
    }
    @@direction_code = @@directional.invert

    @@street_type = {
      "allee" => "aly",
      "alley" => "aly",
      "ally" => "aly",
      "anex" => "anx",
      "annex" => "anx",
      "annx" => "anx",
      "arcade" => "arc",
      "av" => "ave",
      "aven" => "ave",
      "avenu" => "ave",
      "avenue" => "ave",
      "avn" => "ave",
      "avnue" => "ave",
      "bayoo" => "byu",
      "bayou" => "byu",
      "beach" => "bch",
      "bend" => "bnd",
      "bluf" => "blf",
      "bluff" => "blf",
      "bluffs" => "blfs",
      "bot" => "btm",
      "bottm" => "btm",
      "bottom" => "btm",
      "boul" => "blvd",
      "boulevard" => "blvd",
      "boulv" => "blvd",
      "branch" => "br",
      "brdge" => "brg",
      "bridge" => "brg",
      "brnch" => "br",
      "brook" => "brk",
      "brooks" => "brks",
      "burg" => "bg",
      "burgs" => "bgs",
      "bypa" => "byp",
      "bypas" => "byp",
      "bypass" => "byp",
      "byps" => "byp",
      "camp" => "cp",
      "canyn" => "cyn",
      "canyon" => "cyn",
      "cape" => "cpe",
      "causeway" => "cswy",
      "causway" => "cswy",
      "cen" => "ctr",
      "cent" => "ctr",
      "center" => "ctr",
      "centers" => "ctrs",
      "centr" => "ctr",
      "centre" => "ctr",
      "circ" => "cir",
      "circl" => "cir",
      "circle" => "cir",
      "circles" => "cirs",
      "ck" => "crk",
      "cliff" => "clf",
      "cliffs" => "clfs",
      "club" => "clb",
      "cmp" => "cp",
      "cnter" => "ctr",
      "cntr" => "ctr",
      "cnyn" => "cyn",
      "common" => "cmn",
      "corner" => "cor",
      "corners" => "cors",
      "course" => "crse",
      "court" => "ct",
      "courts" => "cts",
      "cove" => "cv",
      "coves" => "cvs",
      "cr" => "crk",
      "crcl" => "cir",
      "crcle" => "cir",
      "crecent" => "cres",
      "creek" => "crk",
      "crescent" => "cres",
      "cresent" => "cres",
      "crest" => "crst",
      "crossing" => "xing",
      "crossroad" => "xrd",
      "crscnt" => "cres",
      "crsent" => "cres",
      "crsnt" => "cres",
      "crssing" => "xing",
      "crssng" => "xing",
      "crt" => "ct",
      "curve" => "curv",
      "dale" => "dl",
      "dam" => "dm",
      "div" => "dv",
      "divide" => "dv",
      "driv" => "dr",
      "drive" => "dr",
      "drives" => "drs",
      "drv" => "dr",
      "dvd" => "dv",
      "estate" => "est",
      "estates" => "ests",
      "exp" => "expy",
      "expr" => "expy",
      "express" => "expy",
      "expressway" => "expy",
      "expw" => "expy",
      "extension" => "ext",
      "extensions" => "exts",
      "extn" => "ext",
      "extnsn" => "ext",
      "falls" => "fls",
      "ferry" => "fry",
      "field" => "fld",
      "fields" => "flds",
      "flat" => "flt",
      "flats" => "flts",
      "ford" => "frd",
      "fords" => "frds",
      "forest" => "frst",
      "forests" => "frst",
      "forg" => "frg",
      "forge" => "frg",
      "forges" => "frgs",
      "fork" => "frk",
      "forks" => "frks",
      "fort" => "ft",
      "freeway" => "fwy",
      "freewy" => "fwy",
      "frry" => "fry",
      "frt" => "ft",
      "frway" => "fwy",
      "frwy" => "fwy",
      "garden" => "gdn",
      "gardens" => "gdns",
      "gardn" => "gdn",
      "gateway" => "gtwy",
      "gatewy" => "gtwy",
      "gatway" => "gtwy",
      "glen" => "gln",
      "glens" => "glns",
      "grden" => "gdn",
      "grdn" => "gdn",
      "grdns" => "gdns",
      "green" => "grn",
      "greens" => "grns",
      "grov" => "grv",
      "grove" => "grv",
      "groves" => "grvs",
      "gtway" => "gtwy",
      "harb" => "hbr",
      "harbor" => "hbr",
      "harbors" => "hbrs",
      "harbr" => "hbr",
      "haven" => "hvn",
      "havn" => "hvn",
      "height" => "hts",
      "heights" => "hts",
      "hgts" => "hts",
      "highway" => "hwy",
      "highwy" => "hwy",
      "hill" => "hl",
      "hills" => "hls",
      "hiway" => "hwy",
      "hiwy" => "hwy",
      "hllw" => "holw",
      "hollow" => "holw",
      "hollows" => "holw",
      "holws" => "holw",
      "hrbor" => "hbr",
      "ht" => "hts",
      "hway" => "hwy",
      "inlet" => "inlt",
      "island" => "is",
      "islands" => "iss",
      "isles" => "isle",
      "islnd" => "is",
      "islnds" => "iss",
      "jction" => "jct",
      "jctn" => "jct",
      "jctns" => "jcts",
      "junction" => "jct",
      "junctions" => "jcts",
      "junctn" => "jct",
      "juncton" => "jct",
      "key" => "ky",
      "keys" => "kys",
      "knol" => "knl",
      "knoll" => "knl",
      "knolls" => "knls",
      "la" => "ln",
      "lake" => "lk",
      "lakes" => "lks",
      "landing" => "lndg",
      "lane" => "ln",
      "lanes" => "ln",
      "ldge" => "ldg",
      "light" => "lgt",
      "lights" => "lgts",
      "lndng" => "lndg",
      "loaf" => "lf",
      "lock" => "lck",
      "locks" => "lcks",
      "lodg" => "ldg",
      "lodge" => "ldg",
      "loops" => "loop",
      "manor" => "mnr",
      "manors" => "mnrs",
      "meadow" => "mdw",
      "meadows" => "mdws",
      "medows" => "mdws",
      "mill" => "ml",
      "mills" => "mls",
      "mission" => "msn",
      "missn" => "msn",
      "mnt" => "mt",
      "mntain" => "mtn",
      "mntn" => "mtn",
      "mntns" => "mtns",
      "motorway" => "mtwy",
      "mount" => "mt",
      "mountain" => "mtn",
      "mountains" => "mtns",
      "mountin" => "mtn",
      "mssn" => "msn",
      "mtin" => "mtn",
      "neck" => "nck",
      "orchard" => "orch",
      "orchrd" => "orch",
      "overpass" => "opas",
      "ovl" => "oval",
      "parks" => "park",
      "parkway" => "pkwy",
      "parkways" => "pkwy",
      "parkwy" => "pkwy",
      "passage" => "psge",
      "paths" => "path",
      "pikes" => "pike",
      "pine" => "pne",
      "pines" => "pnes",
      "pk" => "park",
      "pkway" => "pkwy",
      "pkwys" => "pkwy",
      "pky" => "pkwy",
      "place" => "pl",
      "plain" => "pln",
      "plaines" => "plns",
      "plains" => "plns",
      "plaza" => "plz",
      "plza" => "plz",
      "point" => "pt",
      "points" => "pts",
      "port" => "prt",
      "ports" => "prts",
      "prairie" => "pr",
      "prarie" => "pr",
      "prk" => "park",
      "prr" => "pr",
      "rad" => "radl",
      "radial" => "radl",
      "radiel" => "radl",
      "ranch" => "rnch",
      "ranches" => "rnch",
      "rapid" => "rpd",
      "rapids" => "rpds",
      "rdge" => "rdg",
      "rest" => "rst",
      "ridge" => "rdg",
      "ridges" => "rdgs",
      "river" => "riv",
      "rivr" => "riv",
      "rnchs" => "rnch",
      "road" => "rd",
      "roads" => "rds",
      "route" => "rte",
      "rvr" => "riv",
      "shoal" => "shl",
      "shoals" => "shls",
      "shoar" => "shr",
      "shoars" => "shrs",
      "shore" => "shr",
      "shores" => "shrs",
      "skyway" => "skwy",
      "spng" => "spg",
      "spngs" => "spgs",
      "spring" => "spg",
      "springs" => "spgs",
      "sprng" => "spg",
      "sprngs" => "spgs",
      "spurs" => "spur",
      "sqr" => "sq",
      "sqre" => "sq",
      "sqrs" => "sqs",
      "squ" => "sq",
      "square" => "sq",
      "squares" => "sqs",
      "station" => "sta",
      "statn" => "sta",
      "stn" => "sta",
      "str" => "st",
      "strav" => "stra",
      "strave" => "stra",
      "straven" => "stra",
      "stravenue" => "stra",
      "stravn" => "stra",
      "stream" => "strm",
      "street" => "st",
      "streets" => "sts",
      "streme" => "strm",
      "strt" => "st",
      "strvn" => "stra",
      "strvnue" => "stra",
      "sumit" => "smt",
      "sumitt" => "smt",
      "summit" => "smt",
      "terr" => "ter",
      "terrace" => "ter",
      "throughway" => "trwy",
      "tpk" => "tpke",
      "tr" => "trl",
      "trace" => "trce",
      "traces" => "trce",
      "track" => "trak",
      "tracks" => "trak",
      "trafficway" => "trfy",
      "trail" => "trl",
      "trails" => "trl",
      "trk" => "trak",
      "trks" => "trak",
      "trls" => "trl",
      "trnpk" => "tpke",
      "trpk" => "tpke",
      "tunel" => "tunl",
      "tunls" => "tunl",
      "tunnel" => "tunl",
      "tunnels" => "tunl",
      "tunnl" => "tunl",
      "turnpike" => "tpke",
      "turnpk" => "tpke",
      "underpass" => "upas",
      "union" => "un",
      "unions" => "uns",
      "valley" => "vly",
      "valleys" => "vlys",
      "vally" => "vly",
      "vdct" => "via",
      "viadct" => "via",
      "viaduct" => "via",
      "view" => "vw",
      "views" => "vws",
      "vill" => "vlg",
      "villag" => "vlg",
      "village" => "vlg",
      "villages" => "vlgs",
      "ville" => "vl",
      "villg" => "vlg",
      "villiage" => "vlg",
      "vist" => "vis",
      "vista" => "vis",
      "vlly" => "vly",
      "vst" => "vis",
      "vsta" => "vis",
      "walks" => "walk",
      "well" => "wl",
      "wells" => "wls",
      "wy" => "way"
    }
  
    @@street_type_list = {}
    @@street_type.to_a.each{|item| @@street_type_list[item[0]] = true; @@street_type_list[item[1]] = true}

    @@state_code = {
      "alabama" => "AL",
      "alaska" => "AK",
      "american samoa" => "AS",
      "arizona" => "AZ",
      "arkansas" => "AR",
      "california" => "CA",
      "colorado" => "CO",
      "connecticut" => "CT",
      "delaware" => "DE",
      "district of columbia" => "DC",
      "federated states of micronesia" => "FM",
      "florida" => "FL",
      "georgia" => "GA",
      "guam" => "GU",
      "hawaii" => "HI",
      "idaho" => "ID",
      "illinois" => "IL",
      "indiana" => "IN",
      "iowa" => "IA",
      "kansas" => "KS",
      "kentucky" => "KY",
      "louisiana" => "LA",
      "maine" => "ME",
      "marshall islands" => "MH",
      "maryland" => "MD",
      "massachusetts" => "MA",
      "michigan" => "MI",
      "minnesota" => "MN",
      "mississippi" => "MS",
      "missouri" => "MO",
      "montana" => "MT",
      "nebraska" => "NE",
      "nevada" => "NV",
      "new hampshire" => "NH",
      "new jersey" => "NJ",
      "new mexico" => "NM",
      "new york" => "NY",
      "north carolina" => "NC",
      "north dakota" => "ND",
      "northern mariana islands" => "MP",
      "ohio" => "OH",
      "oklahoma" => "OK",
      "oregon" => "OR",
      "palau" => "PW",
      "pennsylvania" => "PA",
      "puerto rico" => "PR",
      "rhode island" => "RI",
      "south carolina" => "SC",
      "south dakota" => "SD",
      "tennessee" => "TN",
      "texas" => "TX",
      "utah" => "UT",
      "vermont" => "VT",
      "virgin islands" => "VI",
      "virginia" => "VA",
      "washington" => "WA",
      "west virginia" => "WV",
      "wisconsin" => "WI",
      "wyoming" => "WY"
    }

    @@state_name = @@state_code.invert
    
    @@state_fips = {
      "01" => "AL",
      "02" => "AK",
      "04" => "AZ",
      "05" => "AR",
      "06" => "CA",
      "08" => "CO",
      "09" => "CT",
      "10" => "DE",
      "11" => "DC",
      "12" => "FL",
      "13" => "GA",
      "15" => "HI",
      "16" => "ID",
      "17" => "IL",
      "18" => "IN",
      "19" => "IA",
      "20" => "KS",
      "21" => "KY",
      "22" => "LA",
      "23" => "ME",
      "24" => "MD",
      "25" => "MA",
      "26" => "MI",
      "27" => "MN",
      "28" => "MS",
      "29" => "MO",
      "30" => "MT",
      "31" => "NE",
      "32" => "NV",
      "33" => "NH",
      "34" => "NJ",
      "35" => "NM",
      "36" => "NY",
      "37" => "NC",
      "38" => "ND",
      "39" => "OH",
      "40" => "OK",
      "41" => "OR",
      "42" => "PA",
      "44" => "RI",
      "45" => "SC",
      "46" => "SD",
      "47" => "TN",
      "48" => "TX",
      "49" => "UT",
      "50" => "VT",
      "51" => "VA",
      "53" => "WA",
      "54" => "WV",
      "55" => "WI",
      "56" => "WY",
      "72" => "PR",
      "78" => "VI"
    }

    @@fips_state = @@state_fips.invert
    
    @@ordinals = {
      'first' => 1,
      'one' => 1,
      'ten' => 10,
      'tenth' => 10,
      'eleven' => 11,
      'eleventh' => 11,
      'twelfth' => 12,
      'twelve' => 12,
      'thirteen' => 13,
      'thirteenth' => 13,
      'fourteen' => 14,
      'fourteenth' => 14,
      'fifteen' => 15,
      'fifteenth' => 15,
      'sixteen' => 16,
      'sixteenth' => 16,
      'seventeen' => 17,
      'seventeenth' => 17,
      'eighteen' => 18,
      'eighteenth' => 18,
      'nineteen' => 19,
      'nineteenth' => 19,
      'second' => 2,
      'two' => 2,
      'twentieth' => 20,
      'twenty' => 20,
      'third' => 3,
      'three' => 3,
      'four' => 4,
      'fourth' => 4,
      'fifth' => 5,
      'five' => 5,
      'six' => 6,
      'sixth' => 6,
      'seven' => 7,
      'seventh' => 7,
      'eight' => 8,
      'eighth' => 8,
      'nine' => 9,
      'ninth' => 9
    }
    
    @@ordinals_regexp = @@ordinals.keys.join("|")
    @@street_type_regexp = @@street_type_list.keys.join("|")
    @@number_regexp = '\d+-?\d*'
    @@fraction_regexp = '\d+\/\d+'
    @@state_regexp = @@state_code.to_a.join("|").gsub(/ /, "\\s")
    @@direct_regexp = @@directional.keys.join("|") + "|" + @@directional.values.sort{|a,b| b.length <=> a.length }.map{|x| f = x.gsub(/(\w)/, '\1.'); [Regexp::quote(f), Regexp::quote(x)] }.join("|")
    @@zip_regexp = '(\d{5})(?:-(\d{4}))?'
    @@corner_regexp = '(?:\band\b|\bat\b|&|\@)'
    @@unit_regexp = '(?:(su?i?te|p\W*[om]\W*b(?:ox)?|dept|apt|apartment|ro*m|fl|unit|box)\W+|\#\W*)([\w-]+)'
    @@street_regexp = 
      '(?:
          (?:(' + @@direct_regexp + ')\W+
          (' + @@street_type_regexp + ')\b)
          |
          (?:(' + @@direct_regexp + ')\W+)?
          (?:
            ([^,]+)
            (?:[^\w,]+(' + @@street_type_regexp + ')\b)
            (?:[^\w,]+(' + @@direct_regexp + ')\b)?
           |
            ([^,]*\d)
            (' + @@direct_regexp + ')\b
           |
            ([^,]+?)
            (?:[^\w,]+(' + @@street_type_regexp + ')\b)?
            (?:[^\w,]+(' + @@direct_regexp + ')\b)?
          )
        )'
    @@place_regexp = 
      '(?:
       ([^\d,]+?)\W+
       ($' + @@state_regexp + ')\W*
       )?
       (?:' + @@zip_regexp + ')?'
    
    @@address_regexp =
      '\A\W*
        (' + @@number_regexp + ')\W*
        (?:' + @@fraction_regexp + '\W*)?' +
        @@street_regexp + '\W+
        (?:' + @@unit_regexp + '\W+)?' +
        @@place_regexp +
      '\W*\Z'
      
    class << self
=begin rdoc

    parses either an address or intersection and returns an instance of
    StreetAddress::US::Address or nil if the location cannot be parsed
    
====example
    StreetAddress::US.parse('1600 Pennsylvania Ave Washington, DC 20006')
    or:
    StreetAddress::US.parse('Hollywood & Vine, Los Angeles, CA')
    
=end
      def parse(location)
        regex = Regexp.new(@@corner_regexp, Regexp::IGNORECASE)
        if  regex.match(location)
          z = regex.match(location)
          parse_intersection(location);
        else 
          parse_address(location);
        end
      end

=begin rdoc
    
    parses only an intersection and returnsan instance of
    StreetAddress::US::Address or nil if the intersection cannot be parsed
    
====example
    address = StreetAddress::US.parse('Hollywood & Vine, Los Angeles, CA')
    assert address.intersection?
    
=end
      def parse_intersection(inter)
        regex = Regexp.new(
          '\A\W*' + @@street_regexp + '\W*?
          \s+' + @@corner_regexp + '\s+' +
          @@street_regexp + '\W+' +
          @@place_regexp + '\W*\Z', Regexp::IGNORECASE + Regexp::EXTENDED)
        match = regex.match(inter)
        return if match.nil?

        normalize_address(
          StreetAddress::US::Address.new(
            :street => match[4] || match[9],
            :street_type => match[5],
            :suffix => match[6],
            :prefix => match[3],
            :street2 => match[15] || match[20],
            :street_type2 => match[16],
            :suffix2 => match[17],
            :prefix2 => match[14],
            :city => match[23],
            :state => match[24],
            :postal_code => match[25]
          )
        )
      end
      
=begin rdoc

    parses only an address and returnsan instance of
    StreetAddress::US::Address or nil if the address cannot be parsed

====example
    address = StreetAddress::US.parse('1600 Pennsylvania Ave Washington, DC 20006')
    assert !address.intersection?

=end
      def parse_address(addr)
         regex = Regexp.new(@@address_regexp, Regexp::IGNORECASE + Regexp::EXTENDED)
         match = regex.match(addr)
         return if match.nil?

         normalize_address(
           StreetAddress::US::Address.new(
           :number => match[1],
           :street => match[5] || match[10] || match[2],
           :street_type => match[6] || match[3],
           :unit => match[14],
           :unit_prefix => match[13],
           :suffix => match[7] || match[12],
           :prefix => match[4],
           :city => match[15],
           :state => match[16],
           :postal_code => match[17],
           :postal_code_ext => match[18]
           )
        )
      end
      
      def state_name #:nodoc:
        @@state_name
      end
      
      def fips_state #:nodoc:
        @@fips_state
      end
      
      private
      def normalize_address(addr)
        addr.state = normalize_state(addr.state) unless addr.state.nil?
        addr.street_type = normalize_street_type(addr.street_type) unless addr.street_type.nil?
        addr.prefix = normalize_directional(addr.prefix) unless addr.prefix.nil?
        addr.suffix = normalize_directional(addr.suffix) unless addr.suffix.nil?
        addr.street.gsub!(/\b([a-z])/) {|wd| wd.capitalize} unless addr.street.nil?
        addr.street = normalize_ordinals(addr.street) unless addr.street.nil?
        addr.street_type2 = normalize_street_type(addr.street_type2) unless addr.street_type2.nil?
        addr.prefix2 = normalize_directional(addr.prefix2) unless addr.prefix2.nil?
        addr.suffix2 = normalize_directional(addr.suffix2) unless addr.suffix2.nil?
        addr.street2.gsub!(/\b([a-z])/) {|wd| wd.capitalize} unless addr.street2.nil?
        addr.city.gsub!(/\b([a-z])/) {|wd| wd.capitalize} unless addr.city.nil?
        addr.unit_prefix.capitalize! unless addr.unit_prefix.nil?
        return addr
      end
      
      def normalize_state(state)
        if state.length < 3
          state.upcase
        else
          @@state_code[state.downcase]
        end
      end
      
      def normalize_street_type(s_type)
        s_type.downcase!
        s_type = @@street_type[s_type] || s_type if @@street_type_list[s_type]
        s_type.capitalize
      end
      
      def normalize_directional(dir)
        if dir.length < 3
          dir.upcase
        else
          @@directional[dir.downcase]
        end
      end
      
      # Convert spelled out ordinals into a numeric ordinal string
      def normalize_ordinals(text)
        words = text.scan(Regexp.new(@@ordinals_regexp, true))
        return text if words.empty?
        num = words.inject(0) {|sum, word| sum += @@ordinals[word.downcase]; sum }
        text.sub(words.join(' '), ordinalize(num))
      end
      
      
      # Turns a number into an ordinal string used to denote the position in an
      # ordered sequence such as 1st, 2nd, 3rd, 4th.
      #
      # Examples:
      #   ordinalize(1)     # => "1st"
      #   ordinalize(2)     # => "2nd"
      #   ordinalize(1002)  # => "1002nd"
      #   ordinalize(1003)  # => "1003rd"
      #   ordinalize(-11)   # => "-11th"
      #   ordinalize(-1021) # => "-1021st"
      #
      # Taken from ActiveSupport
      def ordinalize(number)
        if (11..13).include?(number.to_i.abs % 100)
          "#{number}th"
        else
          case number.to_i.abs % 10
            when 1; "#{number}st"
            when 2; "#{number}nd"
            when 3; "#{number}rd"
            else    "#{number}th"
          end
        end
      end
      
    end

=begin rdoc
  
    This is class returned by StreetAddress::US::parse, StreetAddress::US::parse_address 
    and StreetAddress::US::parse_intersection.  If an instance represents an intersection
    the attribute street2 will be populated.
  
=end
    class Address
      attr_accessor :number, :street, :street_type, :unit, :unit_prefix, :suffix, :prefix, :city, :state, :postal_code, :postal_code_ext, :street2, :street_type2, :suffix2, :prefix2

      def initialize(args)
        args.keys.each { |attrib| self.send("#{attrib}=", args[attrib]) }
      end

      def state_fips
        StreetAddress::US::fips_state[@state]
      end

      def state_name
        s_name = StreetAddress::US.state_name[state]     
        s_name.capitalize unless s_name.nil?
      end

      def intersection?
        !street2.nil?
      end

      def to_s
        s = ""
        if intersection?
          s += prefix + " " unless prefix.nil?
          s += street 
          s += " " + street_type unless street_type.nil?
          s += " " + suffix unless suffix.nil?
          s += " and"
          s += " " + prefix2 unless prefix2.nil?
          s += " " + street2
          s += " " + street_type2 unless street_type2.nil?
          s += " " + suffix2 unless suffix2.nil?
          s += ", " + city unless city.nil?
          s += ", " + state unless state.nil?
          s += " " + postal_code unless postal_code.nil?
        else
          s += number
          s += " " + prefix unless prefix.nil?
          s += " " + street unless street.nil?
          s += " " + street_type unless street_type.nil?
          if( !unit_prefix.nil? && !unit.nil? )
            s += " " + unit_prefix 
            s += " " + unit
          elsif( unit_prefix.nil? && !unit.nil? )
            s += " #" + unit
          end
          s += " " + suffix unless suffix.nil?
          s += ", " + city unless city.nil?
          s += ", " + state unless state.nil?
          s += " " + postal_code unless postal_code.nil?
          s += "-" + postal_code_ext unless postal_code_ext.nil?
        end
        return s
      end  
    end
  end
end
