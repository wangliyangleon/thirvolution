# Load the Rails application.
require_relative 'application'

Dir["#{::Rails.root}/lib/*.rb"].each do |filename|
  require filename
end


# Initialize the Rails application.
Rails.application.initialize!
