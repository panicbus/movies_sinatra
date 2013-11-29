require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

MOVIES = []

get '/' do
  erb :form
end

get '/movies' do

  movie_title = params[:movie_title]

  movies = Typhoeus.get(
    "http://www.omdbapi.com",  # the website to be called
    :params => { :s => movie_title } #calling the second parameter on the get request and look inside for the diff parameter the query string leads
  )

  p @results = JSON.parse(movies.body)["Search"]

# added following two lines Sun
  # movie_details = Typhoeus.get("http://www.omdbapi.com", :params => {:s => movie_title})
  # p @details = JSON.parse(movie_details.body)["Search"]


 # raise @results.inspect

  if @results == nil
    erb :not_found
  else
    erb :index
  end
end


get '/movies/show/:id' do
  movie_id = params[:id] #gather id from the user

  movie = Typhoeus.get( # retrieve info from database and parse
    "http://www.omdbapi.com",
    :params => { :i => movie_id }
  )
  @result = JSON.parse(movie.body) # parsing the result set

  erb :show #rendering the view
end

get 'movies/show/not_found' do
  erb :not_found
end
