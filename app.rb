require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end
    
    get '/todos' do 
        @todos=db.execute('SELECT * FROM todos')
        ap @todos
        erb(:'todos/index') 
    end

    get '/todos/new' do  
        erb(:'todos/new')
    end

    get '/todos/:id' do |id|
        @todo=db.execute('SELECT * FROM todos WHERE id=?', id).first
        ap @todo
        erb(:'todos/show')
    end

    post '/todos' do
        ap params
        f_name = params["todos_name"]
        f_description = params["todos_description"]
        db.execute("INSERT INTO todos (name, description) VALUES (?, ?)", [f_name, f_description])
        redirect("/todos")
    end
end