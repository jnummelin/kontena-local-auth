begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
end

ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']

require 'roda'
require 'json'
require 'mutations'
require 'logger'
require 'tilt/jbuilder.rb'
require 'active_support'

Dir[__dir__ + '/initializers/*.rb'].each {|file| require file }

Dir[__dir__ + '/helpers/*.rb'].each {|file| require file }

Dir[__dir__ + '/models/*.rb'].each {|file| require file }

Dir[__dir__ + '/mutations/**/*.rb'].each {|file| require file }