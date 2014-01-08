require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'rake'
require 'chronic'
require 'bcrypt'
require 'rack-flash'
require 'stock_quote'

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
	if current_user
		redirect "/dashboard/#{current_user.id}"
	else
		haml :index
	end
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
		redirect '/registration'
	end
end

get '/registration' do
	haml :registration
end

post '/registration' do
	@user = User.new(params['user'])
	if @user.save
		session[:user_id] = @user.id
		flash[:notice] = "Welcome to MockStocks!"
		redirect '/'
	else
		flash[:alert] = "There was a problem with your registration."
		redirect '/registration'
	end
end

get '/logout' do
	session[:user_id] = nil
	flash[:notice] = "Come back soon!"
	redirect '/'
end

get '/dashboard/:id' do
	@user = User.find(params[:id])
	@portfolio = @user.portfolios.find(:all)
	haml :dashboard
end

get '/transactions' do
	haml :transactions
end

post '/transactions' do
	@transaction = Transaction.new(params['transaction'])
	stock_info = StockQuote::Stock.quote(@transaction.symbol)
	@transaction.price = stock_info.ask
	@transaction.created_at = Time.now
	redirect '/transactions'
end