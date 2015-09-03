module Lita
  module Handlers
    class SlackOutgoingHook < Handler
      # Lita HTTP Endpoint for Slack
      http.post '/lita/slack-ooutgoing-hook', :receive

      # Class method called by Lita for handler configuration
      def self.default_config(default)
        default.webhook_token =nil
        default.team_domain = nil
        default.ignore_user_name = nil
      end

      def receive(req, res)
        if not config_valid?
          res.status = 500
          return
        end
        log.debug 'SlackOutgoingHook::receive started'

        if not request_valid?(req)
          res.status = 403
          return
        end

        res.status = 200

        log.debug "SlackOutgoingHook::receive webhook_token:#{req['token']} team_domain:#{req['team_domain']}"
        log.debug "SlackOutgoingHook::receive user id:#{req['user_id']} name:#{req['user_name']}"
        log.debug "SlackOutgoingHook::receive room id:#{req['channel_id']} name:#{req['channel_name']}"
        log.debug "SlackOutgoingHook::receive message text #{req['text']}"
        log.debug "SlackOutgoingHook::receive message text size #{req['text'].size} byte(s)"
        log.debug "SlackOutgoingHook::receive req.params #{req.params}"

        user = User.create(req['user_id'], name: req['user_name'], mention_name: req['user_name'])
        room = User.create(req['channel_id'], name: req['channel_name'])
        source = Source.new(user: user, room: room.id)
        message = Message.new(robot, req['text'], source)
        log.info 'SlackOutgoingHook::receive routing message to the adapter'

        robot.receive message
        log.debug 'SlackOutgoingHook::receive ending'
      end

      def config_valid?
        valid = true
        if config.webhook_token.nil?
          log.error 'SlackOutgoingHook: refuse to run; missing config "webhook_token"'
          valid = false
        end
        if config.team_domain.nil?
          log.error 'SlackOutgoingHook: refuse to run; missing "team_domain"'
          valid = false
        end
        return valid
      end

      def request_valid?(req)
        valid = true
        if req['token'] != config.webhook_token
          log.warn "SlackOutgoingHook: ignoring request; token does not match (received:#{req['token']})"
          valid = false
        end
        if req['team_domain'] != config.team_domain
          log.warn "SlackOutgoingHook: ignoring request; team domain does not match (received:#{req['team_domain']})"
          valid = false
        end
        return valid
      end

      def ignore?(req)
        ignore = false
        if !config.ignore_user_name.nil? && req['user_name'].eql?(config.ignore_user_name)
          log.warn "SlackOutgoingHook: #{req['user_name']} matches ignore_user_name #{config.ignore_user_name}"
          ignore = true
        end
        return ignore
      end

      def log
        Lita.logger
      end

      def config
        Lita.config.handlers.slack_outgoing_hook
      end
      Lita.register_handler(self)
    end
  end
end
