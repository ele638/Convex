require "./r2point"
require "./deq"

# Абстрактная фигура
class Figure
	def distance; nil end
  def perimeter; 0.0 end
  def area;      0.0 end
  def angle;     0.0 end
  def initialize(point1, point2)
	@point1 = point1; @point2 = point2
  end
end

# "Hульугольник"
class Void < Figure
  def add(p)
    Point.new(p, @point1, @point2)
  end
end

# "Одноугольник"
class Point < Figure
  def initialize(p, point1, point2) 
	super(point1, point2)    
	@p = p	
  end
  def add(q)
    @p == q ? self : Segment.new(@p, q, @point1, @point2)
  end
end

# "Двуугольник"
class Segment < Figure
	attr_reader :p, :q, :point1, :point2
	
  def initialize(p, q, point1 = @point1, point2 = @point2) 
	super(point1, point2)    
	@p, @q = p, q
  end
  def perimeter()
    2.0 * @p.dist(@q)
  end
	
	# Находим угол
	def angle()
		angle =(cross? and is_on_segments?) ? (Math.acos(((m1 = self.point2.x - self.point1.x)*(m2 = self.q.x - self.p.x) + (n1 = self.point2.y - self.point1.y)*(n2 = self.q.y - self.p.y))/(Math.sqrt(m1*m1 + n1*n1)*Math.sqrt(m2*m2 + n2*n2)))*180.0/Math::PI).round(4) : 0.0
		angle > 180.0 - angle ? 180 - angle : angle
	end
  
	def add(r) 
    if R2Point.triangle?(@p, @q, r)
      return Polygon.new(@p, @q, r, @point1, @point2)
    end
    return Segment.new(@p, r, @point1, @point2) if @q.inside?(@p, r)
    return Segment.new(r, @q, @point1, @point2) if @p.inside?(r, @q) 
    self
  end
	# Пересекаются ли прямые, на которых лежит ребро выпуклой оболочки и заданный отрезок?
	def cross?()
		(self.point1.x == self.point2.x and self.p.x == self.q.x) ? false : ((self.point2.y - self.point1.y)/(self.point2.x - self.point1.x) == (self.q.y - self.p.y)/(self.q.x - self.p.x)) ? false : true
	end
	
	# Находим точку пересечения
	def cross_point()
		if self.point1.x != self.point2.x  #если первая прямая не вертикальна
			if self.p.x != self.q.x          #если вторая прямая не вертикальна
				b1 = self.point1.y - (k1 = (self.point2.y - self.point1.y)/(self.point2.x - self.point1.x))*self.point1.x   #блаблабла
				b2 = self.p.y - (k2 = (self.q.y - self.p.y)/(self.q.x - self.p.x))*self.p.x
				xc = (b2 - b1)/(k1 - k2)
				return R2Point.new(xc, xc*k1 + b1)
			else
				b1 = self.point1.y - (k1 = (self.point2.y - self.point1.y)/(self.point2.x - self.point1.x))*self.point1.x
	      yc = k1*self.p.x + b1
		    return R2Point.new(self.p.x, yc)
      end		
		elsif self.p.x != self.q.x         #если первая вертикальна, а вторая нет
			k2 = (self.q.y-self.p.y)/(self.q.x-self.p.x)
	    b2 = self.p.y - k2*self.p.x
			return R2Point.new(self.point1.x, k2*self.point1.x + b2)
		end	
	end
	
	# Является ли найденная точка пересечения прямых - точкой пересечения отрезков?
	def is_on_segments?()
		#cross? ? ((c = cross_point).dist(self.point1) + c.dist(self.point2) == self.point1.dist(self.point2) and c.dist(self.p) + c.dist(self.q) == self.p.dist(self.q)) : false ### альтернативная реализация
		cross? ? ((c = cross_point).inside?(self.point1, self.point2) and c.inside?(self.p, self.q)) : false
	end
end

# Многоугольник
class Polygon < Figure
  attr_reader :points, :perimeter, :area, :angle

  def initialize(a, b, c, point1, point2)
	super(point1,point2) 
    @points    = Deq.new
    @points.push_first(b)
    if b.light?(a,c) 
      @points.push_first(a)
      @points.push_last(c)
    else
      @points.push_last(a)
      @points.push_first(c)
    end
    @perimeter = a.dist(b) + b.dist(c) + c.dist(a)
    @area      = R2Point.area(a, b, c).abs
		@angle     = Segment.new(a, b, @point1, @point2).angle + Segment.new(b, c, @point1, @point2).angle + Segment.new(c, a, @point1, @point2).angle
  end

  # добавление новой точки
  def add(t)

    # поиск освещённого ребра
    @points.size.times do 
      break if t.light?(@points.last, @points.first)
      @points.push_last(@points.pop_first)
    end

    # хотя бы одно освещённое ребро есть
    if t.light?(@points.last, @points.first)

      # учёт удаления ребра, соединяющего конец и начало дека
      @perimeter -= @points.first.dist(@points.last)
      @area      += R2Point.area(t, @points.last, @points.first).abs
			@angle     -= Segment.new(@points.first, @points.last, @point1, @point2).angle

      # удаление освещённых рёбер из начала дека
      p = @points.pop_first
      while t.light?(p, @points.first)
        @perimeter -= p.dist(@points.first)
	      @area      += R2Point.area(t, p, @points.first).abs
				@angle     -= Segment.new(@points.first, p, @point1, @point2).angle
        p = @points.pop_first
      end
      @points.push_first(p)

      # удаление освещённых рёбер из конца дека
      p = @points.pop_last
      while t.light?(@points.last, p)
        @perimeter -= p.dist(@points.last)
	      @area      += R2Point.area(t, p, @points.last).abs
				@angle     -= Segment.new(@points.last, p, @point1, @point2).angle
        p = @points.pop_last
      end
      @points.push_last(p)

      # добавление двух новых рёбер 
      @perimeter += t.dist(@points.first) + t.dist(@points.last)
			@angle     += Segment.new(@points.last, t, @point1, @point2).angle + Segment.new(@points.first, t, @point1, @point2).angle
      @points.push_first(t)
    end

    self
  end
end
