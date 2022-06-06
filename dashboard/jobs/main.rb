current_connections = 0
current_load = 0
points = []
(1..10).each do |i|
  points << { x: i, y: rand(50) }
end

clients = ['NYPD', 'BPD', 'FBI', 'NSA', 'CIA']
client_counts = Hash.new({ value: 0 })
last_x = points.last[:x]

SCHEDULER.every '5s' do
  random_client = clients.sample
  client_counts[random_client] = { label: random_client, value: (client_counts[random_client][:value] + 1) % 30 }
  last_connections = current_connections
  last_load  = current_load
  current_connections = rand(100)
  current_load    = rand(200000)
  points.shift
  last_x += 1
  points << { x: last_x, y: rand(50) }
  send_event('connections', { current: current_connections, last: last_connections })
  send_event('traffic', { current: current_load, last: last_load })
  send_event('load',   { value: rand(100) })
  send_event('traffic', points: points)
  send_event('clients', { items: client_counts.values })
end