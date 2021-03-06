require 'nokogiri'

module Discourse

  class XmlParser

    include Logging

    # Returns a Nokogiri Class Hierarchy.
    def call(body)
      return {} unless body
      info("XmlParser#call => #{body}")

      Nokogiri::XML(body).remove_namespaces!
    end

  end

end
