require 'io/console'

namespace :slammer do
  namespace :authentication do
    desc 'Test authentication.'
    task test: :environment do |task, args|
      include Slammer::AuthenticationProcessor
      print "Username: "
      username = STDIN.gets.chomp
      print "Password (won't be shown): "
      password = STDIN.noecho(&:gets).chomp
      2.times { puts }
      puts "Testing credentials against #{authenticators.length} authenticators"
      authenticators.each do |authenticator_name, authenticator|
        puts "'#{authenticator_name}' (#{authenticator.class}):"
        print '  '
        begin
          if data = authenticator.validate(username, password)
            p data
          else
            puts "Invalid credentials"
          end
        rescue Slammer::Authenticator::AuthenticatorError => e
          puts "#{e}"
        end
      end
    end
  end
end
