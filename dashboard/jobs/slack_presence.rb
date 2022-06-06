require 'slack'

options = {
    :api_token => ''
}

slack_client = Slack::Client.new token: options[:api_token]

status_map = {
    'active' => 'Active',
    'away' => 'Away',
    'dnd' => 'Do Not Disturb',
    '' => 'Offline'
}

SCHEDULER.every '30s' do


  users_response = slack_client.users_list(presence: 1)
  dnd_response = slack_client.dnd_teamInfo

  slack_members = users_response["members"]
  slack_dnd = dnd_response["users"]

  slack_members.each do |u|

    target = "slack-presence-#{u['name']}"

    data = {
        :fullname => u['real_name'],
        :img => u['profile']['image_72'],
        :presence_class => u['presence']
    }

    if slack_dnd[u['id']] && slack_dnd[u['id']]['dnd_enabled']
      now = Time.now.to_i
      dnd_data = slack_dnd[u['id']]
      if now >= dnd_data['next_dnd_start_ts'] && now <= dnd_data['next_dnd_end_ts']
        data[:presence_class] = 'dnd'
      end
    end

    data[:presence_name] = status_map[data[:presence_class]]

    send_event(target, data)
  end

end
