# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module SignInHelper
  def sign_in_as(user)
    post session_path, params: { email_address: user.email_address, password: "password" }
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end


class ActiveSupport::TestCase
  setup :clean_database
  teardown :clean_database

  private

  def clean_database
    # Clear dependent tables first to avoid foreign key constraint errors
    dependent_models = [ Session, Borrowing ]  # Replace with models that reference other models
    dependent_models.each do |model|
      model.delete_all
    end

    # Clear parent tables after dependent tables
    parent_models = [ User, Book ]  # Replace with models that are referenced by others
    parent_models.each do |model|
      model.delete_all
    end
  end
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
