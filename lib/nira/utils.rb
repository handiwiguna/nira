module Nira
  module Utils

    def normalize_url(url)
      URI.encode url
    end
    module_function :normalize_url

    def absolutify_url(base, href)
      href = URI.parse(URI.encode(href))
      URI.parse(base).merge(href).to_s
    end
    module_function :absolutify_url
  end
end
