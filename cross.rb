  def cross(x1, y1, x2, y2, x3, y3, x4, y4) 
   if x1 != x2
    if x3 != x4
     k1=(self.point2.y-self.point1.y).to_f/(self.point2.x-self.point1.x)
     b1=self.point1.y-k1*self.point1.x
     k2=(self.q.y-self.p.y).to_f/(self.q.x-self.p.x)
     b2=self.p.y-k2*self.p.x
     xp=(b2-b1).to_f/(k1-k2)
     yp=k1*xp+b1
	 return 0 if k1 == k2 and b1 == b2
     return true if (R2Point.new(xp,yp).dist(R2Point.new(x3,y3))+R2Point.new(xp,yp).dist(R2Point.new(x4,y4))-R2Point.new(x3,y3).dist(R2Point.new(x4,y4))).abs<=0.00000001
     return false
    else
     
   b1 = self.point1.y - (k1 = (self.point2.y - self.point1.y)/(self.point2.x - self.point1.x))*self.point1.x
	 yc = k1*self.p.x + b1
		return R2Point.new(self.p.x, yc)
     return true if (R2Point.new(xp,yp).dist(R2Point.new(x3,y3))+R2Point.new(xp,yp).dist(R2Point.new(x4,y4))-R2Point.new(x3,y3).dist(R2Point.new(x4,y4))).abs<=0.00000001
     return false
    end
   else	
    if x3!=x4
	 k2 = (self.q.y-self.p.y)/(self.q.x-self.p.x)
	 b2 = self.p.y) - k2*self.p.x
     xc=x1
	 yp = k2*self.point1.x + b2
	 return R2Point.new(self.point1.x, k2*self.point1.x + b2)
	 return true if (R2Point.new(xp,yp).dist(R2Point.new(x3,y3))+R2Point.new(xp,yp).dist(R2Point.new(x4,y4))-R2Point.new(x3,y3).dist(R2Point.new(x4,y4))).abs<=0.00000001
     return false
	else 
	 return false if x3!=x1
	 return "INFINITY" if x1==x3
	end 
   end
  end
  if $0==__FILE__
   x1,y1,x2,y2,x3,y3,x4,y4=gets.to_f,gets.to_f,gets.to_f,gets.to_f,gets.to_f,gets.to_f,gets.to_f,gets.to_f
   p cross(x1,y1,x2,y2,x3,y3,x4,y4) 
  end