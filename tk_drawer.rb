require "tk"
# Графический интерфейс выпуклой оболочки (модуль) 
module TkDrawer
  # запуск интерпретатора графического интерфейса
  def TkDrawer.create
    CANVAS.pack{padx 5; pady 5}; Thread.new{Tk.mainloop}
  end
  # "стирание" картинки и рисование осей координат  
  def TkDrawer.clean 
    TkcRectangle.new(CANVAS, 0, 0, SIZE, SIZE, "width"=>0) {fill("white")}
    TkcLine.new(CANVAS, 0, SIZE/2, SIZE, SIZE/2) {fill("blue")}
    TkcLine.new(CANVAS, SIZE/2, 0, SIZE/2, SIZE) {fill("blue")}
  end
  # рисование точки
  def TkDrawer.draw_point(p)
    TkcOval.new(CANVAS, x(p) + 1, y(p) + 1, x(p) - 1, y(p) - 1) {fill("black")}
  end
  # рисование линии
  def TkDrawer.draw_line(p,q)
    TkcLine.new(CANVAS, x(p), y(p), x(q), y(q)) {fill("black")}    
  end
  # рисование треугольника (добавлено)
  def TkDrawer.draw_poly(a,b,c)
	TkcPolygon.new(CANVAS, x(a), y(a), x(b), y(b), x(c), y(c), 'fill'=>'green')
  end
  # рисование окрестности (добавлено)
   def TkDrawer.draw_line_1(p,q) 
    TkcLine.new(CANVAS, x(p), y(p), x(q), y(q), 'width'=>'100', 'fill'=>'green' )    
  end
  # рисование кругов (добавлено)
   def TkDrawer.draw_circle(p)
    TkcOval.new(CANVAS, x(p) + 50, y(p) + 50, x(p) - 50, y(p) - 50, 'fill'=>"green")
  end
  private
  # преобразование координат
  def TkDrawer.x(p)
    SIZE/2 + SCALE*p.x
  end
  def TkDrawer.y(p)
    SIZE/2 - SCALE*p.y
  end
  # Размер окна и коэффициент гомотетии
  SIZE   = 600; SCALE  = 50
  # Корневое окно графического интерфейса
  ROOT   = TkRoot.new{title "Convex"; geometry "#{SIZE+5}x#{SIZE+5}"}
  # Окно для рисования
  CANVAS = TkCanvas.new(ROOT, "height"=>SIZE, "width"=>SIZE)
end

# Определение метода draw для классов выпуклой оболочки
class Figure
  def draw
    TkDrawer.clean
	TkDrawer.draw_poly(@@a,@@b,@@c)
	TkDrawer.draw_line_1(@@a,@@b)
	TkDrawer.draw_line_1(@@b,@@c)
	TkDrawer.draw_line_1(@@a,@@c)
	TkDrawer.draw_circle(@@a)
	TkDrawer.draw_circle(@@b)
	TkDrawer.draw_circle(@@c)
  end
end
class Point < Figure
  def draw
    super
    TkDrawer.draw_point(@p)

  end
end
class Segment < Figure
  def draw
    super
    TkDrawer.draw_line(@p,@q)
  end
end
class Polygon < Figure
  def draw
    super 
    @points.size.times do 
      TkDrawer.draw_line(@points.last, @points.first)
      @points.push_last(@points.pop_first)
    end
  end
end
