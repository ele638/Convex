# Точка (Point) на плоскости (R2)
class R2Point 
  attr_reader :x, :y

  # конструктор
  def initialize(x = input("x"), y = input("y")) 
    @x, @y = x, y
  end

  # площадь треугольника (метод класса)
  def R2Point.area(a, b, c) 
    0.5*((a.x-c.x)*(b.y-c.y)-(a.y-c.y)*(b.x-c.x))
  end

  # лежат ли точки на одной прямой? (метод класса)
  def R2Point.triangle?(a, b, c) 
    area(a, b, c) != 0.0
  end

  # расстояние до другой точки
  def dist(other) 
    Math.sqrt((other.x-@x)**2 + (other.y-@y)**2)
  end

  # лежит ли точка внутри "стандартного" прямоугольника?
  def inside?(a, b) 
    ((a.x <= @x and @x <= b.x) or 
     (a.x >= @x and @x >= b.x)) and
      ((a.y <= @y and @y <= b.y) or 
       (a.y >= @y and @y >= b.y)) 
  end

  # освещено ли из данной точки ребро (a,b)?
  def light?(a, b) 
    s = R2Point.area(a, b, self)
    s < 0.0 or (s == 0.0 and !inside?(a, b))
  end
  
  # совпадает ли точка с другой?
  def == (other) 
    @x == other.x and @y == other.y
  end
  
  # расстояние от точки до отрезка (добавлено)
  def dist_segm(a,b)
	return (((a.y-b.y)*@x)+((b.x-a.x)*@y)+(a.x*b.y-b.x*a.y))/Math.sqrt( (b.x-a.x)**2 + (b.y-a.y)**2 )
  end
  
  # лежит ли внутри треугольника c окрестностью (добавлено)
  def is_inside?(a,b,c)
	if self.light?(a,b) && self.light?(b,c) && self.light?(c,a) #если внутри треугольника
		true
	elsif (@x-a.x)**2+(@y-a.y)**2<=1 || (@x-b.x)**2+(@y-b.y)**2<=1 || (@x-c.x)**2+(@y-c.y)**2<=1 #если внутри окружностей
		true
	elsif (dist_segm(a,b)>=0 && dist_segm(a,b)<=1) || (dist_segm(a,c)>=0 && dist_segm(a,c)<=1)  || (dist_segm(b,c)>=0 && dist_segm(b,c)<=1)   #если в окрестности
		true
	else
		false
	end
  end

  private
  def input(prompt)
    print "#{prompt} -> "
    readline.to_f
  end
end
