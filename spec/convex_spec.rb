require 'rspec'
require_relative "../convex"

EPS = 1.0e-12

describe Void do

  let(:fig) { Void.new(R2Point.new(0,0),R2Point.new(0,0),R2Point.new(0,0)) } #пустой ввод для прогона эталонных тестов

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

  it "При добавлении точки нульугольник превращается в одноугольник" do
    expect(fig.add(R2Point.new(0.0,0.0))).to be_an_instance_of(Point)
  end
end

describe Point do

  let(:fig) { Point.new(R2Point.new(0.0,0.0)) }

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

  it "При добавлении точки одноугольник может не измениться" do
    expect(fig.add(R2Point.new(0.0,0.0))).to equal(fig)
  end

  it "При добавлении точки одноугольник может стать двуугольником" do
    expect(fig.add(R2Point.new(1.0,0.0))).to be_an_instance_of(Segment)
  end
end

describe Segment do

  let(:fig) { Segment.new(R2Point.new(0.0,0.0), R2Point.new(1.0,0.0)) }

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
end

describe Polygon do

  let(:fig) do
    a = R2Point.new(0.0,0.0)
    b = R2Point.new(1.0,0.0)
    c = R2Point.new(0.0,1.0)
    fig = Polygon.new(a,b,c)
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
end


describe Void do #добавленные тесты
	
	let(:fig) { Void.new(R2Point.new(0,0),R2Point.new(3,0),R2Point.new(3,3)) } #мой треугольник в тестах А(0,0), В(3,0), С(3,3)
	
	context "Метод inside_points" do
	
		it "Возвращает nil, если оболочка - нульугольник" do
			expect(fig.inside_points).to be nil
		end
	  
		it "Возвращает 1 при добавлении точки 0,0" do
			expect(fig.add(R2Point.new(0,0)).inside_points).to be 1
		end
		
		it "Возвращает 0 при добавлении точки -5,0" do
			expect(fig.add(R2Point.new(-5,0)).inside_points).to be 0
		end
		
		let(:fig1) do 
			fig1=Void.new(R2Point.new(0,0),R2Point.new(3,0),R2Point.new(3,3))
			a=R2Point.new(-5,0)
			b=R2Point.new(0,0)
			fig1=Segment.new(a,b) #тестируем работу с отрезком
		end

		it "Конструктор порождает экземпляр класса Segment (двуугольник)" do #тесты эталонного варианта не нарушены, типы оболочек соблюдаются
			expect(fig1).to be_an_instance_of(Segment)
		end

		it "Возвращает 1 при добавлении точки a(0,0) и точки b(-5,0)" do
			expect(fig1.inside_points).to be 1
		end
		
		it "Возвращает 1 при добавлении точки 1,0" do
			expect(fig1.add(R2Point.new(1,0)).inside_points).to be 1
		end
		
		it "Возвращает 0 при добавлении точки 10,0" do
			expect(fig1.add(R2Point.new(10,0)).inside_points).to be 0
		end
		
		let(:fig2) do
			fig2 = Void.new(R2Point.new(0,0),R2Point.new(3,0),R2Point.new(3,3))
			a = R2Point.new(2,1)
			b = R2Point.new(5,0)
			c = R2Point.new(0,0)
			fig2 = Polygon.new(a,b,c) #тестируем многоугольники
		end
		
		it "конструктор порождает экземпляр класса Polygon (многоугольник)" do #тесты эталонного варианта не нарушены, типы оболочек соблюдаются
		  expect(fig2).to be_an_instance_of(Polygon)
		end
		
		it "Возвращает 2 при добавлении точки a(1,1), точки b(5,0) и точки c(0,0)" do
			expect(fig2.inside_points).to be 2
		end
		
		it "Возвращает 1 при добавлении точки 4,4" do 
			expect(fig2.add(R2Point.new(4,4)).inside_points).to be 1
		end
		
		it "Возвращает 2  при добавлении точки 4,3" do
			expect(fig2.add(R2Point.new(4,3)).inside_points).to be 2
		end
		
		it "Возвращает 2  при добавлении точки 2,3" do
			expect(fig2.add(R2Point.new(2,3)).inside_points).to be 2
		end
		
		it "Возвращает 3  при добавлении точек 4,3 и 2,3" do
			expect(fig2.add(R2Point.new(4,3)).add(R2Point.new(2,3)).inside_points).to be 3
		end
		
		it "Возвращает 2  при добавлении точек 4,3 , 2,3 и 4,4" do
			expect(fig2.add(R2Point.new(4,3)).add(R2Point.new(2,3)).add(R2Point.new(4,4)).inside_points).to be 2
		end
	end
end
