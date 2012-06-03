require 'uri'

begin
	require 'team'

class Baseball < Linkbot::Plugin
    def self.on_message(message, match)
	def on_message(match)
		if !match || match.length < 2
			"!baseball [team] [date]\nTeams: #{Team::teams.keys.join(' ')}\nDate Format: DD-MM-YYYY or today (default) or yesterday"
		else
			date = [Date.today.year, Date.today.month, Date.today.day]
			if match.length == 3
				if match[2] == "yesterday"
					date = [(Date.today - 1).year, (Date.today - 1).month, (Date.today - 1).day]
				elsif match[2] =~ /(\d{2})-(\d{2})-(\d{4})/
					dmatch = match[2].match(/(\d{2})-(\d{2})-(\d{4})/)
					date = [dmatch[0],dmatch[1],dmatch[2]]
				elsif match[2] != "today"
					raise "ERROR: Date should be DD-MM-YYYY or today or yesterday"
				end
			end
	      begin
				puts "Getting linescore for team: #{match[1]} on date: #{date}"
				t = Team.new(match[1])
				g = t.games_for_date(date[0],date[1],date[2])
				s = ''
				g.each { |h| s += h.print_linescore + "\n" }
			rescue ArgumentError => e
				s = 'ERROR: ' + e
			rescue
				s = 'An unknown error occurred!'
			end
			s
		end
    end

    def help
      "!baseball [team] [date] - Gets baseball scores! (no args gives more help)"
    end

    Linkbot::Plugin.register('baseball', self,
      {
        :message => {:regex => /!baseball\s*(\w*)\s*(.*)/i, :handler => :on_message, :help => :help},
        :"direct-message" => {:regex => /!baseball\s*(\w*)\s*(.*)/i, :handler => :on_message, :help => :help}
      }
    )
end

rescue LoadError
	puts '!baseball plugin requires gameday_api (sudo gem install gameday_api)'
end
