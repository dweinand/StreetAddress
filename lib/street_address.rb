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
    Directional = {
      "north" => "N",
      "northeast" => "NE",
      "east" => "E",
      "southeast" => "SE",
      "south" => "S",
      "southwest" => "SW",
      "west" => "W",
      "northwest" => "NW"
    }
    DirectionCode = Directional.invert

    StreetType = {
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
  
    StreetTypeList = {}
    StreetType.to_a.each{|item| StreetTypeList[item[0]] = true; StreetTypeList[item[1]] = true}

    StateCode = {
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

    StateName = StateCode.invert
    
    StateFips = {
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

    FipsState = StateFips.invert
    
    Ordinals = {
      'first'       => 1,
      'one'         => 1,
      'ten'         => 10,
      'tenth'       => 10,
      'eleventh'    => 11,
      'eleven'      => 11,
      'twelfth'     => 12,
      'twelve'      => 12,
      'thirteenth'  => 13,
      'thirteen'    => 13,
      'fourteenth'  => 14,
      'fourteen'    => 14,
      'fifteenth'   => 15,
      'fifteen'     => 15,
      'sixteenth'   => 16,
      'sixteen'     => 16,
      'seventeenth' => 17,
      'seventeen'   => 17,
      'eighteenth'  => 18,
      'eighteen'    => 18,
      'nineteenth'  => 19,
      'nineteen'    => 19,
      'second'      => 2,
      'two'         => 2,
      'twentieth'   => 20,
      'twenty'      => 20,
      'third'       => 3,
      'three'       => 3,
      'fourth'      => 4,
      'four'        => 4,
      'fifth'       => 5,
      'five'        => 5,
      'sixth'       => 6,
      'six'         => 6,
      'seventh'     => 7,
      'seven'       => 7,
      'eighth'      => 8,
      'eight'       => 8,
      'ninth'       => 9,
      'nine'        => 9
    }
    
    OrdinalsRegexp = Ordinals.keys.join('\b|')
    StreetTypeRegexp = StreetTypeList.keys.join("|")
    NumberRegexp = '\d+-?\d*'
    FractionRegexp = '\d+\/\d+'
    StateRegexp = StateCode.to_a.join("|").gsub(/ /, "\\s")
    DirectRegexp = Directional.keys.join("|") + "|" + Directional.values.sort{|a,b| b.length <=> a.length }.map{|x| f = x.gsub(/(\w)/, '\1.'); [Regexp::quote(f), Regexp::quote(x)] }.join("|")
    ZipRegexp = '(\d{5})(?:-(\d{4}))?'
    CornerRegexp = '(?:\band\b|\bat\b|&|\@)'
    UnitRegexp = '(?:(su?i?te|p\W*[om]\W*b(?:ox)?|dept|apt|apartment|ro*m|fl|unit|box)\W+|\#\W*)([\w-]+)'
    StreetRegexp = 
      '(?:
          (?:(' + DirectRegexp + ')\W+
          (' + StreetTypeRegexp + ')\b)
          |
          (?:(' + DirectRegexp + ')\W+)?
          (?:
            ([^,]+)
            (?:[^\w,]+(' + StreetTypeRegexp + ')\b)
            (?:[^\w,]+(' + DirectRegexp + ')\b)?
           |
            ([^,]*\d)
            (' + DirectRegexp + ')\b
           |
            ([^,]+?)
            (?:[^\w,]+(' + StreetTypeRegexp + ')\b)?
            (?:[^\w,]+(' + DirectRegexp + ')\b)?
          )
        )'
    PlaceRegexp = 
      '(?:
       ([^\d,]+?)\W+
       ($' + StateRegexp + ')\W*
       )?
       (?:' + ZipRegexp + ')?'
    
    AddressRegexp =
      '\A\W*
        (' + NumberRegexp + ')\W*
        (?:' + FractionRegexp + '\W*)?' +
        StreetRegexp + '\W+
        (?:' + UnitRegexp + '\W+)?' +
        PlaceRegexp +
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
        regex = Regexp.new(CornerRegexp, Regexp::IGNORECASE)
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
          '\A\W*' + StreetRegexp + '\W*?
          \s+' + CornerRegexp + '\s+' +
          StreetRegexp + '\W+' +
          PlaceRegexp + '\W*\Z', Regexp::IGNORECASE + Regexp::EXTENDED)
        match = regex.match(inter)
        return if match.nil?

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

      end
      
=begin rdoc

    parses only an address and returnsan instance of
    StreetAddress::US::Address or nil if the address cannot be parsed

====example
    address = StreetAddress::US.parse('1600 Pennsylvania Ave Washington, DC 20006')
    assert !address.intersection?

=end
      def parse_address(addr)
        regex = Regexp.new(AddressRegexp, Regexp::IGNORECASE + Regexp::EXTENDED)
        match = regex.match(addr)
        return if match.nil?

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
      end
      
    end

=begin rdoc
  
    This is class returned by StreetAddress::US::parse, StreetAddress::US::parse_address 
    and StreetAddress::US::parse_intersection.  If an instance represents an intersection
    the attribute street2 will be populated.
  
=end
    class Address
      attr_accessor :number, :street, :street_type, :unit, :unit_prefix,
                    :suffix, :prefix, :city, :state, :postal_code,
                    :postal_code_ext, :street2, :street_type2, :suffix2,
                    :prefix2

      def initialize(args)
        args.keys.each { |attrib| self.send("#{attrib}=", args[attrib]) }
        normalize!
      end

      def state_fips
        FipsState[state]
      end

      def state_name
        s_name = StateName[state]
        s_name.capitalize if s_name
      end

      def intersection?
        !street2.nil?
      end
      
      def street_name
        [prefix,street,street_type,suffix].compact.join(' ')
      end
      
      def street_name2
        [prefix2,street2,street_type2,suffix2].compact.join(' ')
      end
      
      def street_address
        [
          number,
          street_name,
          (unit_prefix || '#' if unit),
          unit
        ].compact.join(' ')
      end
      
      def city_state_postal_code
        [
          ("#{city}," if city),
          state, postal_code, postal_code_ext
        ].compact.join(' ')
      end

      def to_s
        if intersection?
          [
            street_name,
            'and',
            ("#{street_name2}," if street_name2),
            city_state_postal_code
          ].compact.join(' ')
        else
          [
            street_address,
            city_state_postal_code
          ].compact.join(', ')
        end
      end  
      
      def normalize!
        normalize_state
        normalize_street_types
        normalize_directionals
        normalize_ordinals
        normalize_capitalization
      end
      
      private
      
      def normalize_state
        return unless state
        if state.size < 3
          state.upcase!
        else
          self.state = StateCode[state.downcase]
        end
      end
      
      def normalize_street_types
        self.street_type = normalize_street_type(street_type)
        self.street_type2 = normalize_street_type(street_type2)
      end
      
      def normalize_street_type(str_type)
        return unless str_type
        str_type.downcase!
        str_type = StreetType[str_type].dup if StreetType[str_type]
        str_type.capitalize!
      end
      
      def normalize_directionals
        self.prefix = normalize_directional(prefix)
        self.suffix = normalize_directional(suffix)
        self.prefix2 = normalize_directional(prefix2)
        self.suffix2 = normalize_directional(suffix2)
      end
      
      def normalize_directional(dir)
        return unless dir
        if dir.length < 3
          dir.upcase
        else
          Directional[dir.downcase]
        end
      end
      
      def normalize_ordinals
        self.street = normalize_ordinal(street)
        self.street2 = normalize_ordinal(street2)
      end
      
      def normalize_ordinal(str)
        return unless str
        words = str.scan(Regexp.new(OrdinalsRegexp, true))
        return str if words.empty?
        num = words.inject(0) {|sum, wd| sum += Ordinals[wd.downcase]; sum }
        str.sub(words.join(' '), ordinalize(num))
      end
      
      def normalize_capitalization
        street.gsub!(/\b([a-z])/) {|wd| wd.capitalize} if street
        street2.gsub!(/\b([a-z])/) {|wd| wd.capitalize} if street2
        city.gsub!(/\b([a-z])/) {|wd| wd.capitalize } if city
        unit_prefix.capitalize! if unit_prefix
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
  end
end
