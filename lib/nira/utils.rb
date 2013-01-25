module Nira
  class Utils

    def self.normalize_url(url)
      URI.encode url
    end

    def self.absolutify_url(base, href)
      href = URI.encode(href)
      URI.parse(base).merge(href).to_s
    end
  end
end
