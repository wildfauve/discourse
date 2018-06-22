module Discourse

  class HtmlParser

    def call(body)
      Nokogiri::XML(body)
    end

  end

end
