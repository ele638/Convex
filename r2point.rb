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
	return ((((a.y-b.y)*@x)+((b.x-a.x)*@y)+(a.x*b.y-b.x*a.y))/Math.sqrt( (b.x-a.x)**2 + (b.y-a.y)**2 )).abs
  end
  
  def ugol(k) # угол наклона прямой (добавлено)
  	  tx=k.x-@x
  	  ty=k.y-@y
  	  if tx!=0 && ty!=0
  	  	Math.acos(tx/Math.sqrt(tx**2+ty**2))*180/Math::PI
  	  else
  	  	0
  	  end
  end
  
  def newpoint(b)
  	p self.ugol(b)
  	if self.ugol(b)>45
  		tempx1=b.x - Math.sin(self.ugol(b))
  		tempy1=b.y - Math.cos(self.ugol(b))
  		tempx2=@x - Math.sin(self.ugol(b))
  		tempy2=@y - Math.cos(self.ugol(b))
  	else
  		tempx1=b.x + Math.sin(self.ugol(b))
  		tempy1=b.y + Math.cos(self.ugol(b))
  		tempx2=@x + Math.sin(self.ugol(b))
  		tempy2=@y + Math.cos(self.ugol(b))
  	end
  	a=R2Point.new(tempx1,tempy1)
  	r=R2Point.new(tempx2,tempy2)
  end
  # лежит ли внутри треугольника c окрестностью (добавлено)
  def is_inside?(a,b,c)
	if !(self.light?(a,b) || self.light?(b,c) || self.light?(a,c)) #если внутри треугольника
		return true
	elsif (@x-a.x)**2+(@y-a.y)**2<=1 || (@x-b.x)**2+(@y-b.y)**2<=1 || (@x-c.x)**2+(@y-c.y)**2<=1 #если внутри окружностей (а надо ли, если расстояние учитывает еденичный радиус?
		return true
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

=begin
a=R2Point.new(0,0)
b=R2Point.new(3,0)
c=R2Point.new(3,3)
d=R2Point.new(2,2)
p d.light?(a,c)
=end