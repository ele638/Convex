#!/usr/bin/env ruby
require "./convex"

fig = Void.new(R2Point.new, R2Point.new)
begin
  while true
    fig = fig.add(R2Point.new)
    puts "S = #{fig.area}, P = #{fig.perimeter} Angle = #{fig.angle}"
  end
rescue EOFError
  puts "\nStop"
end
