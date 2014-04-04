require "./convex"

fig = Void.new
begin
  while true
    fig = fig.add(R2Point.new)
    puts "S = #{fig.area}, P = #{fig.perimeter}, count = #{fig.inside_points}" #вывод ответа (исправлено)
  end
rescue EOFError
  puts "\nStop"
end
