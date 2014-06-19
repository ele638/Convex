require "./r2point"
require "./deq"

# Абстрактная фигура
class Figure
  def perimeter; 0.0 end
  def area;      0.0 end
	def count;     0 end
end

# "Hульугольник"
class Void < Figure
  def add(p)
    Point.new(p)
  end
end

# "Одноугольник"
class Point < Figure
  def initialize(p) 
    @p = p
  end
  def add(q)
    @p == q ? self : Segment.new(@p, q)
  end
end

# "Двуугольник"
class Segment < Figure
	attr_reader :p, :q
  def initialize(p, q) 
    @p, @q = p, q
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
	
	def dist_segment(point)                                                                      ###
		return self.p.dist(point) if (self.q - self.p).multi(point - self.p) < 0
		return self.q.dist(point) if (self.p - self.q).multi(point - self.q) < 0
		return ((self.p - self.q).y*point.x + (self.q - self.p).x*point.y + (self.p.x*self.q.y - self.q.x*self.p.y)).abs/self.p.dist(self.q)
	end
	
	def dist(other)                                                                              ###
		return [other.dist_segment(self.p), other.dist_segment(self.q)].min
	end
end

# Многоугольник
class Polygon < Figure
  attr_reader :points, :perimeter, :area, :count

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
		@count = 0
		@array = [Segment.new(a, b), Segment.new(b, c), Segment.new(c, a)]
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
			@a = Segment.new(@points.first, @points.last)
			for i in 0...@array.size
				if (@array[i].p == @a.p and @array[i].q == @a.q) or (@array[i].p == @a.q and @array[i].q == @a.p)
					@array.delete_at(i) 
					break
				end
			end
		
      # удаление освещённых рёбер из начала дека
      p = @points.pop_first
      while t.light?(p, @points.first)
        @perimeter -= p.dist(@points.first)
				@area      += R2Point.area(t, p, @points.first).abs
				@a = Segment.new(@points.first, p)
				for i in 0...@array.size
					if (@array[i].p == @a.p and @array[i].q == @a.q) or (@array[i].p == @a.q and @array[i].q == @a.p)
						@array.delete_at(i) 
						break
					end
				end
        p = @points.pop_first
      end
      @points.push_first(p)

      # удаление освещённых рёбер из конца дека
      p = @points.pop_last
      while t.light?(@points.last, p)
        @perimeter -= p.dist(@points.last)
				@area      += R2Point.area(t, p, @points.last).abs
				@a = Segment.new(@points.last, p)
				for i in 0...@array.size
					if (@array[i].p == @a.p and @array[i].q == @a.q) or (@array[i].p == @a.q and @array[i].q == @a.p)
						@array.delete_at(i) 
						break
					end
				end
        p = @points.pop_last
      end
      @points.push_last(p)

      # добавление двух новых рёбер 
      @perimeter += t.dist(@points.first) + t.dist(@points.last)
			@a = Segment.new(t, @points.first)
			@b = Segment.new(t, @points.last)
      @count=0
      @array << @a
      @array << @b
      for i in 0...@array.size
        for j in i...@array.size
          @count += 1 if @array[j].dist(@array[i]) <= 1 && @array[j].dist(@array[i]) != 0
        end
      end
      @points.push_first(t)
    end
    self
  end
end
