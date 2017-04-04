require 'sinatra'
require 'pg'
require 'awesome_print'
require 'sinatra/reloader' if development?
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "tiy-database"
)

class Employee < ActiveRecord::Base
  # validates :name, presence: true
  self.primary_key = "id"
end

class Course < ActiveRecord::Base
  # validates :course_name, presence: true
  self.primary_key = "id"
end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  erb :home
end

get '/employees' do
  @employees = Employee.all

  erb :employees
end

get '/employee' do
  @employee = Employee.find(params["id"])
  if @employee
    erb :employee
  else
    erb :no_item_found
  end
end

get '/new_employee' do
  # @employee = Employee.new
  erb :new_employee
end

get '/create_employee' do
  Employee.create(params)
  # @employee = Employee.create(params)
  # if @employee.valid?
  #   redirect('/')
  # else
  #   erb :new_employee
  # end

  redirect('/employees')
end

get '/search_employee' do
  erb :search_employee
end

get '/search_results' do
  search = params["search_param"]

  @employees = Employee.where("name LIKE ? OR github = ? OR slack = ?", "%#{search}%", search, search)

  erb :search_results
end

get '/edit_employee' do
  database = PG.connect(dbname: "tiy-database")

  @employee = Employee.find(params["id"])

  erb :edit_employee
end

get '/update_employee' do
  database = PG.connect(dbname: "tiy-database")

  @employee = Employee.find(params["id"])
  @employee.update_attributes(params)

  redirect('/employees')
end

get '/delete_employee' do
  database = PG.connect(dbname: "tiy-database")

  @employee = Employee.find(params["id"])

  @employee.destroy

  redirect('/employees')
end

get '/courses' do
  @courses = Course.all

  erb :courses
end

get '/course' do
  @course = Course.find(params["id"])
  if @course
    erb :course
  else
    erb :no_item_found
  end
end

get '/new_course' do
  erb :new_course
end

get '/create_course' do
  Course.create(params)

  redirect ('/courses')
end

get '/search_course' do
  erb :search_course
end

get '/search_course_results' do
  which_course = params["search_param"]

  @courses = Course.where("course_name LIKE ?", "%#{which_course}%")

  erb :course_search_results
end

get '/edit_course' do
  database = PG.connect(dbname: "tiy-database")

  @course = Course.find(params["id"])

  erb :edit_course
end

get '/update_course' do
  database = PG.connect(dbname: "tiy-database")

  @course = Course.find(params["id"])
  @course.update_attributes(params)

  redirect('/courses')
end

get '/delete_course' do
  database = PG.connect(dbname: "tiy-database")

  @course = Course.find(params["id"])
  @course.destroy

  redirect to("/courses")
end