class Gag < Linkbot::Plugin

  def self.on_message(message, matches)

    count = matches[0]
    count = count ? count.to_i : 1
    count = count <= 5 ? count : 5

    images = []

    begin
      1.upto(count) do
        #Get the initial 302 response from /random
        url = URI.parse('http://9gag.com/random')
        res = Net::HTTP.get_response(url)

        #Follow the redirect
        url = URI.parse("http://9gag.com#{res['location']}")
        res = Net::HTTP.get(url)

        page = Nokogiri::HTML.parse(res)
        images << page.xpath('//a[@href="/random"]/img/@src')[0].value
      end
    rescue

    end
    return images.join("\n")
  end

  Linkbot::Plugin.register('gag', self, {
    :message => {:regex => /!gag*\s*(\d+)?/i, :handler => :on_message, :help => :help}
  })
end
