require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name = nil, grade = nil)
    @name = name
    @grade = grade
  end 
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT,
        grade INTEGER)
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table 
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def save
    sql = "UPDATE songs SET album = ? WHERE name = ?"
 
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end 
  
  def self.create(hash) 
    student = Student.new(hash[:name], hash[:grade])
    student.save
    student
  end 
  
  def self.new_from_db(row)
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end
end
