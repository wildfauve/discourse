require 'nokogiri'

module Discourse

  class XmlParser

    # Returns a Nokogiri Class Hierarchy.
    def call(body)
      return {} unless body
      Nokogiri::XML(body)
    end

  end

end
