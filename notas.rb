# require 'nombre_de_la_gema'
# declaracion de las gemas que vamos a usar en nuestra app
# notese que 'Shotgun' se instala por Rubygems pero no se declara
# en la aplicacion.
require 'rubygems'
require 'sinatra'
require 'slim'
require 'data_mapper'
# Inicializacion, declarando tipo y path de la base de datos
DataMapper.setup(:default, 'sqlite:db/development.db')

# Habilita un log en la consola que tenga el server corriendo de lo
# que se hace en la base de datos
DataMapper::Logger.new($stdout, :debug)

# Declaracion de clases

class Nota
  include DataMapper::Resource
  property :id, Serial
  property :titulo, String
  property :content, Text
  property :fechaini, Date 
  property :fechafin, Date
  property :estado, String

end


Nota.auto_upgrade!

# Endpoints de nuestra app
get '/' do
  slim :layout
end

get '/nueva' do
  slim :notaNueva
end

post '/nueva' do
  # crea una nueva instancia de Post con los parametros obtenidos del formulario
  nota = Nota.new(:titulo => params[:titulo], :content => params[:content], :fechaini => Time.now, :fechafin=>params[:fechafin], :estado=>"activo")
  if nota.save
    # Si el post se guarda correctamente (true), mostramos /posts
    redirect "/lista"
  else
    # si es false, el post no se guardo correctamente
    p 'Algo salio mal'
  end
end

get "/lista" do 
	@lista = Nota.all
    slim :lista
end

get "/selecciona/:id" do
	@not=Nota.get(params['id'])
	slim :notaEdita
end

post "/update/:id" do
	nota = Nota.get(params['id'])
	nota.update(:titulo => params[:titulo], :content => params[:content], :fechaini => Time.now, :fechafin=>params[:fechafin], :estado=>"activo")
	redirect "/lista"
end

get "/elimina/:id" do
	nota = Nota.get(params['id'])
	nota.destroy
	redirect "/lista"
end

get "/estado/:id" do
	nota = Nota.get(params['id'])
	if nota.estado=="activo"
		nota.update(:estado=>"inactivo")
	else
		nota.update(:estado=>"activo")
	end
	redirect "/lista"
end