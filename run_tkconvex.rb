#!/usr/bin/env ruby
require "./convex"
require "./tk_drawer"

TkDrawer.create
fig = Void.new(R2Point.new,R2Point.new)
fig.draw
begin
  while true
    fig = fig.add(R2Point.new)
    fig.draw
    puts "S = #{fig.area}, P = #{fig.perimeter} Angle = #{fig.angle}"
  end
rescue EOFError
  puts "\nStop"
  sleep 5
end
