require 'sequel'

DB = Sequel.connect("sqlite://#{ENV['DB_PATH'] || 'users.db'}")