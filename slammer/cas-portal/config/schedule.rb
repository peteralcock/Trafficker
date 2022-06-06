env :PATH, "#{ENV["PATH"]}:/usr/local/bin/bundle"

set :output, '/dev/null'

every 5.minutes do
  rake 'slammer:cleanup:all'
end
