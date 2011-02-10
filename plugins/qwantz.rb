class Qwantz < Linkbot::Plugin
    def self.regex
      Regexp.new('!qwantz')
    end
    
    Linkbot::Plugin.register('qwantz', self.regex, self)
  
    def self.on_message(user, message, matches)
        doc = Hpricot(open('http://qwantz.com/index.php'))
        link = doc.search("div.randomquote a")[1]
        doc = Hpricot(open(link['href']))
        img = doc.search('img.comic')
        return [link.inner_html.strip, img.first['src']]
        message = ::Jabber::Message.new(nil,link.to_s)
        handle.send(message,nil)
    end
    
    def self.help
      helpers = [
      "HILARIOUS OUTTAKES COMICS",
      "PHILOSOPHY COMICS",
      "UNINFORMED OPINIONS ABOUT ARCHAEOLOGY COMICS",
      "COMICS WITH NON-TWIST ENDINGS",
      "COMICS FROM THE FUTURE",
      "ENTHUSIASTIC USE OF OUTDATED CATCH-PHRASES COMICS",
      "BAD DECISIONS COMICS"
      ]
      "!qwantz - #{helpers[rand(helpers.length)]}"
    end
end