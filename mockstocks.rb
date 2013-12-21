require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'rake'
require 'chronic'
require 'bcrypt'
require 'rack-flash'

configure(:development) { set :database, 'sqlite3:///mockstocks_db.sqlite3'}

require './models'

enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

helpers do
	def current_user
		if session[:user_id]
			User.find(session[:user_id])
		else
			nil
		end
	end
end

get '/' do
	haml :index
end