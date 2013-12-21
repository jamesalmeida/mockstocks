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

get '/login' do
	haml :login
end

post '/login' do
	@user = User.authenticate(params['user']['username'], params['user']['password'])
	if @user
		session[:user_id] = @user.id
		flash[:notice] = "Welcome back!"
		redirect "/"
	else
		flash[:alert] = "There was a problem with your login."
		redirect '/register'
	end
end

get '/registration' do
	haml :registration
end

post '/register' do
	@user = User.new(params['user'])
	if @user.save
		session[:user_id] = @user.id
		flash[:notice] = "Welcome to MockStocks!"
		redirect '/'
	else
		flash[:alert] = "There was a problem with your registration."
		redirect '/register'
	end
end

get '/logout' do
	session[:user_id] = nil
	flash[:notice] = "Come back soon!"
	redirect '/'
end

