module GnCrossmap
  # Sends data to GN Resolver and collects results
  class Resolver
    URL = "http://resolver.globalnames.org/name_resolvers.json"
    MATCH_TYPES = {
      1 => "Exact match",
      2 => "Canonical form exact match",
      3 => "Canonical form fuzzy match",
      4 => "Partial canonical form match",
      5 => "Partial canonical form fuzzy match",
      6 => "Genus part match"
    }
  end
end
