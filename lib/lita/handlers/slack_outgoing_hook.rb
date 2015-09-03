module Lita
  module Handlers
    class SlackOutgoingHook < Handler
      # insert handler code here

      Lita.register_handler(self)
    end
  end
end
