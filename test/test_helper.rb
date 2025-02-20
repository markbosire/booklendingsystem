# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Display a message if no specific tests are being run

def colorful_message
  red = "\e[31m"
  green = "\e[32m"
  yellow = "\e[33m"
  reset = "\e[0m"

  puts "#{red}🚨 ATTENTION! 🚨#{reset}"
  puts "#{yellow}Please run specific tests using:#{reset}"
  puts "#{green}rails test test/models#{reset} #{yellow}or#{reset} #{green}rails test test/controllers#{reset} #{yellow}or#{reset} #{green}rails test test/views#{reset}"
end

# Display the message if no specific tests are being run
if ARGV.empty?
  colorful_message
  exit
end

module SignInHelper
    SIGNED_COOKIE_SALT = "signed cookie"
  def login_as(user)
  # First, get the authentication token through login
  cookies[:session_id] = Rails.application.message_verifier(SIGNED_COOKIE_SALT).generate(user.sessions.create.id)
  end
end


class ActionDispatch::IntegrationTest
  parallelize(workers: 1)
  include SignInHelper


  setup do
    host! "test.host"
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
