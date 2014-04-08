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
	return ((((a.y-b.y)*@x)+((b.x-a.x)*@y)+(a.x*b.y-b.x*a.y))/Math.sqrt( (b.x-a.x)**2 + (b.y-a.y)**2 )).abs #формула взята с сайта http://algolist.manual.ru/maths/geom/distance/pointline.php
  end
  
  def inside_triangle?(a,b,c) #проверка на принадлежность точки треугольнику
	l=(a.x-@x)*(b.y-a.y)-(b.x-a.x)*(a.y-@y)
	m=(b.x-@x)*(c.y-b.y)-(c.x-b.x)*(b.y-@y)
	n=(c.x-@x)*(a.y-c.y)-(a.x-c.x)*(c.y-@y)
	(l>0 and m>0 and n>0) or (l<0 and m<0 and n<0)
end
  
  # лежит ли внутри треугольника c окрестностью (добавлено)
  def is_inside?(a,b,c)
	if self.inside_triangle?(a,b,c) #если в треугольнике
	  true
	elsif (self.dist_segm(a,b)<1 && self.dist_segm(a,b)>0) ||  (self.dist_segm(b,c)<1 && self.dist_segm(b,c)>0) || (self.dist_segm(c,a)<1 && self.dist_segm(c,a)>0) || (self.dist_segm(a,c)<1 && self.dist_segm(a,c)>0)#расстояние от точки до одной из сторон меньше единицы.
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