class Vehicle
  attr_accessor :current_speed, :color
  attr_reader :year, :model

  @@number_of_vehicles = 0
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def self.number_of_vehicles
    @@number_of_vehicles
  end

  def speed_up(speed)
    self.current_speed += speed
  end

  def brake(speed)
    self.current_speed -= speed
  end

  def shut_off
    self.current_speed = 0
  end

  def get_current_speed
    self.current_speed
  end

  def spray_paint(color)
    self.color = color
  end

  def self.gas_mileage(miles, gallons)
    miles / gallons
  end

  def age
    "Vehicle is #{calculate_age(year)} years old."
  end

  private

  def calculate_age(year)
    ((Time.now - Time.new(year)) / (60 * 60 * 24 * 365.25)).to_i
  end
end

module BreakWalls
  def able_to_break_walls?
    true
  end
end

class Truck < Vehicle
  include BreakWalls
  NEEDS_PERMIT = true
end

class MyCar < Vehicle
  OWNER = 'me'
  def to_s
    "This #{color} car's model is #{model} and was made in #{year}."
  end
end

lumina = MyCar.new(1997, 'white', 'chevy lumina')
lumina.speed_up(20)
lumina.get_current_speed
lumina.speed_up(20)
lumina.get_current_speed
lumina.brake(20)
lumina.get_current_speed
lumina.brake(20)
lumina.get_current_speed
lumina.shut_off
lumina.get_current_speed

lumina.color = 'black'
p lumina.color
p lumina.year

lumina.spray_paint('red')
p lumina.color
MyCar.gas_mileage(351, 13)
puts lumina

tatra = Truck.new(1542, 'white', 'tatra')
p Vehicle.number_of_vehicles

puts MyCar.ancestors
puts Truck.ancestors
puts Vehicle.ancestors
lumina.age
tatra.age

class Student
  protected

  attr_reader :grade

  public

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    student.grade > grade
  end
end
joe = Student.new('Joe', 5)
bob = Student.new('Bob', 4)
joe.better_grade_than?(bob)
joe.grade
