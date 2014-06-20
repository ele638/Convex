require 'rspec'
require_relative "./convex.rb"

EPS = 1.0e-12

describe Void do

  let(:fig) { Void.new(@point1 = R2Point.new(-1.0,1.0),@point2 = R2Point.new(1.0,1.0))}

  it "Конструктор порождает экземпляр класса Void (нульугольник)" do
    expect(fig).to be_an_instance_of(Void)
  end

  it "Нульугольник является фигурой" do
    expect(fig).to be_a_kind_of(Figure)
  end

  it "Периметр нульугольника нулевой" do
    expect(fig.perimeter).to be_within(EPS).of(0.0)
  end

  it "Площадь нульугольника нулевая" do
    expect(fig.area).to be_within(EPS).of(0.0)
  end
	
	it "Сумма углов нулевая" do
    expect(fig.angle).to be_within(EPS).of(0.0)
  end

  it "При добавлении точки нульугольник превращается в одноугольник" do
    expect(fig.add(R2Point.new(0.0,0.0))).to be_an_instance_of(Point)
  end

end

describe Point do

  let(:fig) { Point.new(R2Point.new(0.0,0.0), @point1, @point2) }

  it "Конструктор порождает экземпляр класса Point (одноугольник)" do
    expect(fig).to be_an_instance_of(Point)
  end

  it "Одноугольник является фигурой" do
    expect(fig).to be_a_kind_of(Figure)
  end

  it "Периметр одноугольника нулевой" do
    expect(fig.perimeter).to be_within(EPS).of(0.0)
  end

  it "Площадь одноугольника нулевая" do
    expect(fig.area).to be_within(EPS).of(0.0)
  end
	
	it "Сумма углов нулевая" do
    expect(fig.angle).to be_within(EPS).of(0.0)
  end

  it "При добавлении точки одноугольник может не измениться" do
    expect(fig.add(R2Point.new(0.0,0.0))).to equal(fig)
  end

  it "При добавлении точки одноугольник может стать двуугольником" do
    expect(fig.add(R2Point.new(1.0,0.0))).to be_an_instance_of(Segment)
  end
end

describe Segment do

  let(:fig) { Segment.new(R2Point.new(0.0,0.0), R2Point.new(1.0,0.0), R2Point.new(-1.0,1.0), R2Point.new(1.0,1.0)) }

  it "Конструктор порождает экземпляр класса Segment (двуугольник)" do
    expect(fig).to be_an_instance_of(Segment)
  end

  it "Двуугольник является фигурой" do
    expect(fig).to be_a_kind_of(Figure)
  end

  it "Периметр двуугольника равен удвоенной длине отрезка" do
    expect(fig.perimeter).to be_within(EPS).of(2.0)
  end

  it "Площадь двуугольника нулевая" do
    expect(fig.area).to be_within(EPS).of(0.0)
  end

  it "При добавлении точки двуугольник может не измениться" do
    expect(fig.add(R2Point.new(0.5,0.0))).to equal(fig)
  end

  it "При добавлении точки двуугольник может стать другим двуугольником" do
    fig_new = fig.add(R2Point.new(1.5,0.0))
    expect(fig_new).to be_an_instance_of(Segment)
    expect(fig_new.perimeter).to be_within(EPS).of(3.0)
  end

  it "При добавлении точки двуугольник может стать треугольником" do
    fig_new = fig.add(R2Point.new(0.0,1.0))
    expect(fig_new).to be_an_instance_of(Polygon)
    expect(fig_new.perimeter).to be_within(EPS).of(2.0+Math.sqrt(2.0))
    expect(fig_new.area).to be_within(EPS).of(0.5)
  end
	context "Тестируем новые методы" do
		
		it "Тестируем метод cross?" do
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(0.0,1.0),R2Point.new(1.0,0.0)).cross?).to be_true
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(5.0,5.0),R2Point.new(5.0,0.0)).cross?).to be_true
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),R2Point.new(-4.0,-4.0),R2Point.new(-4.0,0.0)).cross?).to be_true
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(-4.0,-4.0),R2Point.new(-3.0,-3.0)).cross?).to be_false
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),R2Point.new(1.0,1.0),R2Point.new(1.0,0.0)).cross?).to be_true
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),R2Point.new(0.0,2.0),R2Point.new(2.0,2.0)).cross?).to be_false
    end
  	it "Тестируем метод cross_point()" do
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(0.0,1.0),R2Point.new(1.0,0.0)).cross_point).to eq R2Point.new(0.5,0.5)
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(-5.0,0.0),R2Point.new(0.0,0.0)).cross_point).to eq R2Point.new(0.0,0.0)
			expect(Segment.new(R2Point.new(-2.0,1.0),R2Point.new(2.0,1.0),R2Point.new(-0.5,0.0),R2Point.new(-0.5,1.0)).cross_point).to eq R2Point.new(-0.5,1.0)
			expect(Segment.new(R2Point.new(3.0,2.0),R2Point.new(4.0,2.0),R2Point.new(3.5,-4.0),R2Point.new(3.5,3.0)).cross_point).to eq R2Point.new(3.5,2.0)
    end
		
		it "Тестируем метод is_on_segments?" do
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(0.0,1.0),R2Point.new(1.0,0.0)).is_on_segments?).to be_true
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(0.0,5.0),R2Point.new(5.0,2.0),R2Point.new(-5.0,2.0)).is_on_segments?).to be_true
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),R2Point.new(-4.0,-4.0),R2Point.new(0.0,-4.0)).is_on_segments?).to be_false
			expect(Segment.new(R2Point.new(-5.0,-5.0),R2Point.new(-1.0,0.0),R2Point.new(3.0,2.0),R2Point.new(2.0,3.0)).is_on_segments?).to be_false
    end
		
		it "Тестируем метод angle" do
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(0.0,1.0),R2Point.new(1.0,0.0)).angle).to be_within(EPS).of(90.0)
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,1.0),R2Point.new(-5.0,0.0),R2Point.new(0.0,0.0)).angle).to be_within(EPS).of(45.0)
			expect(Segment.new(R2Point.new(-2.0,1.0),R2Point.new(2.0,1.0),R2Point.new(-0.5,0.0),R2Point.new(-0.5,1.0)).angle).to be_within(EPS).of(90.0)
			expect(Segment.new(R2Point.new(0.0,0.0),R2Point.new(1.0,0.0),R2Point.new(-4.0,-4.0),R2Point.new(0.0,-4.0)).angle).to eq 0.0
    end
	end
end



describe Polygon do

  let(:fig) do
    a = R2Point.new(0.0,0.0)
    b = R2Point.new(1.0,0.0)
    c = R2Point.new(0.0,1.0)
    fig = Polygon.new(a,b,c,R2Point.new(-2.0,1.0),R2Point.new(2.0,1.0))
  end
  
  context "Общие свойства:" do

    it "конструктор порождает экземпляр класса Polygon (многоугольник)" do
      expect(fig).to be_an_instance_of(Polygon)
    end

    it "многоугольник является фигурой" do
      expect(fig).to be_a_kind_of(Figure)
    end
end

  context "Изменение количества вершин многоугольника:" do

    it "изначально их три" do
      expect(fig.points.size).to eq 3
    end

    it "добавление точки внутрь многоугольника не меняет их количества" do
      expect(fig.add(R2Point.new(0.1,0.1)).points.size).to eq 3
    end
    
    it "добавление другой точки может изменить их количество" do
      expect(fig.add(R2Point.new(1.0,1.0)).points.size).to eq 4
    end
    
    it "изменения выпуклой оболочки могут и уменьшать их количество" do
      expect(fig.add(R2Point.new(0.4,1.0)).points.size).to eq 4
      expect(fig.add(R2Point.new(1.0,0.4)).points.size).to eq 5
      expect(fig.add(R2Point.new(0.8,0.9)).points.size).to eq 6
      expect(fig.add(R2Point.new(0.9,0.8)).points.size).to eq 7
      expect(fig.add(R2Point.new(2.0,2.0)).points.size).to eq 4
    end

  end

  context "Изменение периметра многоугольника:" do

    it "изначально он равен сумме длин сторон" do
      expect(fig.perimeter).to be_within(EPS).of(2.0+Math.sqrt(2.0))
    end

    it "добавление точки может его изменить" do
      expect(fig.add(R2Point.new(1.0,1.0)).perimeter).to be_within(EPS).of(4.0)
    end
    
    it "изменения выпуклой оболочки могут значительно его увеличить" do
      fig.add(R2Point.new(0.4,1.0))
      fig.add(R2Point.new(1.0,0.4))
      fig.add(R2Point.new(0.8,0.9))
      fig.add(R2Point.new(0.9,0.8))
      fig.add(R2Point.new(2.0,2.0))
      fig.add(R2Point.new(0.0,2.0))
      expect(fig.add(R2Point.new(2.0,0.0)).perimeter).to be_within(EPS).of(8.0)
    end

  end

  context "Изменение площади многоугольника:" do

    it "изначально она равна (неориентированной) площади треугольника" do
      expect(fig.area).to be_within(EPS).of(0.5)
    end

    it "добавление точки может её изменить" do
      expect(fig.add(R2Point.new(1.0,1.0)).area).to be_within(EPS).of(1.0)
    end
    
    it "изменения выпуклой оболочки могут значительно её увеличить" do
      fig.add(R2Point.new(0.4,1.0))
      fig.add(R2Point.new(1.0,0.4))
      fig.add(R2Point.new(0.8,0.9))
      fig.add(R2Point.new(0.9,0.8))
      fig.add(R2Point.new(2.0,2.0))
      fig.add(R2Point.new(0.0,2.0))
      expect(fig.add(R2Point.new(2.0,0.0)).area).to be_within(EPS).of(4.0)
    end

  end
	
	context "Изменение суммы углов пересечения:" do

    it "изначально он равен сумме углов пересечений отрезка со всеми сторонами" do
      expect(fig.angle).to be_within(EPS).of(135.0)
    end

    it "добавление точки может изменить сумму углов" do
      expect(fig.add(R2Point.new(1.0,1.0)).angle).to be_within(EPS).of(180.0)
    end
    
    it "изменения выпуклой оболочки могут значительно изменить сумму углов" do
      fig.add(R2Point.new(2.0,1.0))
      fig.add(R2Point.new(-2.0,1.0))
      fig.add(R2Point.new(-1.0,3.0))
      expect(fig.add(R2Point.new(1.0,3.0)).angle).to be_within(EPS).of(232.125)
    end

  end

end
