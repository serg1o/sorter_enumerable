def bubble_sort(array)
  (array.length - 1).downto(0) do |i|
    0.upto(i - 1) do |i2|
      array[i2], array[i2+1] = array[i2+1], array[i2] if (array[i2] > array[i2+1])
    end
  end
  array
end

def bubble_sort_by(array)
  (array.length - 1).downto(0) do |i|
    0.upto(i - 1) do |i2|
      array[i2], array[i2+1] = array[i2+1], array[i2] if (yield(array[i2], array[i2+1]) > 0)
    end
  end
  array
end

def bubble_sort_by2(array)
  (array.length - 1).downto(0) do |i|
    0.upto(i - 1) do |i2|
      array[i2], array[i2+1] = yield(array[i2], array[i2+1])
    end
  end
  puts array.inspect
end

def bubble_sort_by3(array, &block)
  (array.length - 1).downto(0) do |i|
    0.upto(i - 1) do |i2|
      array[i2], array[i2+1] = block.call(array[i2], array[i2+1])
    end
  end
  puts array.inspect
end

puts "sort arrays using bubble sort"
puts bubble_sort([4,3,78,2,0,2]).inspect
puts bubble_sort([6,8,3,1,5,7,2,4]).inspect

puts "\nsort arrays using bubble sort and passing a block"
puts (bubble_sort_by([6,8,3,1,5,7,2,4]) {|a,b| a <=> b}).inspect
ordered_array = bubble_sort_by(["hi","hello","hey"]) do |left,right|
       left.length - right.length
    end
puts ordered_array.inspect

puts "\nsort arrays using bubble sort and passing a block - version 2"
bubble_sort_by2([4,3,78,2,0,2]) do |a,b|
  if ((a <=> b) == 1)
    a,b = b,a
  else
    a,b = a,b
  end
end

bubble_sort_by2(["hi","hello","hey"]) do |a,b|
  if ((a <=> b) == 1)
    a,b = a,b
  else
    a,b = b,a
  end
end

puts "\nsort arrays using bubble sort and passing a block - version 3"
bubble_sort_by3(["hi","hello","hey"]) do |a,b|
  if ((a <=> b) == 1)
    a,b = a,b
  else
    a,b = b,a
  end
end
