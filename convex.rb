
require "./r2point"
require "./deq"

# Абстрактная фигура
class Figure
  def initialize; @ins=0 end #инициализация счетчика (добавлено)
  def set_triangle(a=R2Point.new, b=R2Point.new, c=R2Point.new) #метод создания треугольника (добавлено)
	  @@a, @@b, @@c = a,b,c
  end 
  def perimeter; 0.0 end
  def area;      0.0 end
  def intr?(p) ; (p.is_inside?(@@a,@@b,@@c)) ? 1 : 0 ;end #проверка, попадает ли точка в треугольник (добавлено)
  def inside_points; @ins; end #вывод ответа (добавлено)
end

# "Hульугольник"
class Void < Figure
  def initialize #нульугольник задает наш треугольник (добавлено)
	set_triangle
  end
  def add(p)
    Point.new(p)
  end
end

# "Одноугольник"
class Point < Figure
  def initialize(p) 
    @p = p
	@ins=intr?(@p) #если точка попадает в треугольник, то ставим счетчик 1 (добавлено)
  end
  def add(q)
    @p == q ? self : Segment.new(@p, q)
  end
end

# "Двуугольник"
class Segment < Figure
  def initialize(p, q) 
    @p, @q = p, q
	@ins=intr?(@p)+intr?(@q) #(добавлено)
  end
  def perimeter
    2.0 * @p.dist(@q)
  end
  def add(r) 
    if R2Point.triangle?(@p, @q, r)
      return Polygon.new(@p, @q, r)
    end
    return Segment.new(@p, r) if @q.inside?(@p, r)
    return Segment.new(r, @q) if @p.inside?(r, @q) 
    self
  end
end

# Многоугольник
class Polygon < Figure
  attr_reader :points, :perimeter, :area 

  def initialize(a, b, c) 
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
	@ins=intr?(a)+intr?(b)+intr?(c) #стартовая оболочка из трех точек (добавлено)
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

      # удаление освещённых рёбер из начала дека
      p = @points.pop_first
      while t.light?(p, @points.first)
        @perimeter -= p.dist(@points.first)
		@area += R2Point.area(t, p, @points.first).abs
		@ins -= intr?(p) #если точка принадлежала, а ее удаляют, то уменьшаем счетчик (добавлено)
        p = @points.pop_first
      end
      @points.push_first(p)

      # удаление освещённых рёбер из конца дека
      p = @points.pop_last
      while t.light?(@points.last, p)
        @perimeter -= p.dist(@points.last)
		@area += R2Point.area(t, p, @points.last).abs
		@ins -= intr?(p) #если точка принадлежала, а ее удаляют, то уменьшаем счетчик (добавлено)
        p = @points.pop_last
      end
      @points.push_last(p)

      # добавление двух новых рёбер 
      @perimeter += t.dist(@points.first) + t.dist(@points.last)
      @points.push_first(t)
	  @ins += intr?(t) #если новая точка попадает в треугольник, то увеличиваем счетчик (добавлено)
    end
    self
  end
end
