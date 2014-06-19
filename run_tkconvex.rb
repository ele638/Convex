#!/usr/bin/env ruby
require "./convex"
require "./tk_drawer"

TkDrawer.create
fig = Void.new
fig.draw
begin
  while true
    fig = fig.add(R2Point.new)
    fig.draw
    puts "S = #{fig.area}, P = #{fig.perimeter}, Count = #{fig.count}"
  end
rescue EOFError
  puts "\nStop"
  sleep 5
end
