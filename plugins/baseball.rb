require 'uri'

begin
	require 'teams'

class Baseball < Linkbot::Plugin
    def self.on_message(message, match)
		if match.length == 0
			"!baseball [team] [date]\nTeams: #{Team::teams.keys.join(' ')}\nDate Format: DD-MM-YYYY or today (default) or yesterday"
		else
			date = [Date.today.year, Date.today.month, Date.today.day]
			if match.length == 2
				if match[1] == "yesterday"
					date = [Date.yesterday.year, Date.yesterday.month, Date.yesterday.day]
				elsif match[1] =~ /(\d{2})-(\d{2})-(\d{4})/
					dmatch = match[1].match(/(\d{2})-(\d{2})-(\d{4})/)
					date = [dmatch[0],dmatch[1],dmatch[2]]
				elsif match[1] != "today"
					"ERROR: Date should be DD-MM-YYYY or today or yesterday"
				end
			end
	      begin
				t = Team.new(match[0])
				g = t.games_for_date(date[0],date[1],date[2])
				s = ''
				g.each { |h| s += h.print_linescore + "\n" }
			rescue ArgumentError e
				s = 'ERROR: ' + e
			end
			s
		end
    end

    def self.help
      "!baseball [team] [date] - Gets baseball scores! (no args gives more help)"
    end

    Linkbot::Plugin.register('baseball', self,
      {
        :message => {:regex => /!baseball (\w*) (.*)/i, :handler => :on_message, :help => :help},
        :"direct-message" => {:regex => /!baseball (.*)/, :handler => :on_message, :help => :help}
      }
    )
end

rescue LoadError
	puts '!baseball plugin requires gameday_api (on GitHub)'
end
