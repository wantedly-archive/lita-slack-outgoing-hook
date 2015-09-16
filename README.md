# lita-slack-outgoing-hook

[![Build Status](https://travis-ci.org/wantedly/lita-slack-outgoing-hook.png?branch=master)](https://travis-ci.org/wantedly/lita-slack-outgoing-hook)

By using slack outgoing webhooks, you can get almost all messages including bot mention

## Installation

**lita-slack-outgoing-hook** is a watch for [Lita](https://github.com/jimmycuadra/lita) that allows you to use the robot with [Slack](https://slack.com/). This watch complements

**lita-slack-outgoing-hook** sets up an HTTP route to accept messages from Slack:Outgoing WebHooks integrations, then feeds it into Lita.

Add lita-slack-outgoing-hook to your Lita instance's Gemfile:

``` ruby
gem "lita-slack-outgoing-hook"
```

## Configuration

**First, you need to make sure your Slack team has [Outgoing WebHooks](https://my.slack.com/services/new/outgoing-webhook) integration setup with the correct Trigger Word(s) and URL:**

```
http://<Lita_server>:<Lita_port>/lita/slack-outgoing-hook
```


### Required attributes

* `webhook_token` (String) – Slack integration token.
* `team_domain` (String) – Slack team domain; subdomain of slack.com.## Configuration



### Sample Configuration

``` ruby
Lita.configure do |config|

  # Lita's HTTP port is used for Slack integration
  config.http.port = 8080

  # lita-slack-outgoing-hook config
  config.watchs.slack_outgoing_hook.webhook_token = ENV["SLACK_WEBHOOK_TOKEN"]
  #example: Cq9wq3TAJp5FGCsUbpzhrKrR
  config.watchs.slack_outgoing_hook.team_domain = ENV["SLACK_TEAM_DOMAIN"]
  #example: koudaiii
  # Some more adapter and other config
  # .....
end
```
