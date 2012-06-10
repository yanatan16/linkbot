
class Answer < Linkbot::Plugin
    def self.on_message(message, match)
       "The answer to life, the universe and everything? 101010."
    end

    def help
      "!answer"
    end

    Linkbot::Plugin.register('baseball', self,
      {
        :message => {:regex => /!answer/i, :handler => :on_message, :help => :help},
        :"direct-message" => {:regex => /!answer/i, :handler => :on_message, :help => :help}
      }
    )
end
