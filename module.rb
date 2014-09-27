#!/usr/bin/ruby

module Enumerable
 
  def my_each
    return self.to_enum if !block_given?
    if self.instance_of?(Hash)
      keys = self.keys
      i = 0
      while i < self.size
        yield(keys[i], self[keys[i]])
        i += 1
      end
    else   
      i = 0
      while i < self.size
        yield(self[i])
        i += 1
      end
    end
    self
  end

  def my_each_with_index
    return self.to_enum if !block_given?
    i = 0
    while i < self.size
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    return self.to_enum if !block_given?
    if self.instance_of?(Hash)
      keys = self.keys
      aux = {}
      keys.my_each do |k|
        aux[k] = self[k] if yield(k, self[k])
      end
    else
      aux = []
      self.my_each do |a|
        aux.push(a) if yield(a)
      end
    end
    aux
  end

  def my_all?
    return self.to_enum if !block_given?
    if self.instance_of?(Hash)
      keys = self.keys
      keys.my_each do |k|
        return false if !yield(k, self[k])
      end
    else
      self.my_each do |a|
        return false if !yield(a)
      end
    end
    true
  end    

  def my_any?
    return self.to_enum if !block_given?
    if self.instance_of?(Hash)
      keys = self.keys
      keys.my_each do |k|
        return true if yield(k, self[k])
      end
    else 
      self.my_each do |a|
        return true if yield(a)
      end
    end
    false
  end

  def my_none?
    return self.to_enum if !block_given?
    if self.instance_of?(Hash)
      keys = self.keys
      keys.my_each do |k|
        return false if yield(k, self[k])
      end
    else
      self.my_each do |a|
        return false if yield(a)
      end
    end
    true
  end

  def my_count
    return self.to_enum if !block_given?
    total = 0
    if self.instance_of?(Hash)
      keys = self.keys
      keys.my_each do |k|
        total += 1 if yield(k, self[k])
      end
    else
      self.my_each do |a|
        total += 1 if yield(a)
      end
    end
    total
  end

  def my_map
    return self.to_enum if !block_given?
    if self.instance_of?(Hash)
      keys = self.keys
      aux = {}
      keys.my_each do |k|
        aux[k] = yield(k, self[k])
      end
    else
      aux = []
      self.my_each do |a|
        aux.push(yield(a))
      end
    end
    aux
  end

  def my_map_proc(&proc)
    return self.to_enum if !block_given?
    if self.instance_of?(Hash)
      keys = self.keys
      aux = {}
      keys.my_each do |k|
        aux[k] = proc.call(k, self[k])
      end
    else
      aux = []
      self.my_each do |a|
        aux.push(proc.call(a))
      end
    end
    aux
  end

  def my_map_proc_block(proc = nil)
    return self.to_enum if (!block_given? && proc.nil?)
    if self.instance_of?(Hash)
      keys = self.keys
      aux = {}
      if (block_given? && !proc.nil?)
        keys.my_each do |k|
          aux[k] = proc.call(k, yield(k, self[k]))
        end
      elsif !proc.nil?
        keys.my_each do |k|
          aux[k] = proc.call(k, self[k])
        end
      end
    else
      aux = []
      if (block_given? && !proc.nil?)
        self.my_each do |a|
          aux.push(proc.call(yield(a)))
        end
      elsif !proc.nil?
        self.my_each do |a|
          aux.push(proc.call(a))
        end
      end
    end
    aux
  end

  def my_inject(init_val)
    return self.to_enum if !block_given?
    total = init_val
    if self.instance_of?(Hash)
      keys = self.keys
      keys.my_each do |k|
        total = yield(total, self[k])
      end
    else  
      self.my_each do |a|
        total = yield(total, a)
      end
    end
    total
  end

  def multiply_els
    self.my_inject(1) do |res, elem|
      res*elem
    end
  end

end



def test1
  hashes = [{"1"=>"Janeiro", "2"=>"Fevereiro", "3"=>"Março"}, {"a"=>12, "b"=>4, "c"=>3}]
  arrays = [[2,4,3,5,67,9], [3,4,5], ["we","erg","fg"]]
  b = Proc.new {|arg| print "#{arg}! "}
  puts arrays[2].my_map_proc(&b)
  puts arrays[2].map(&b)
  b2 = Proc.new {|k, v| print "#{k}! #{v}?"}
  puts hashes[0].my_map_proc(&b2)
  puts hashes[0].map(&b2)

  b3 = Proc.new {|arg| arg + 1}
  puts (arrays[0].my_map_proc_block(b3) {|arg2| arg2 * 2 }).inspect
  puts (arrays[1].my_map_proc_block(b3) {|arg2| arg2 * 2 }).inspect
  b4 = Proc.new {|k1, v1| v1 + 1}  
  puts hashes[1].my_map_proc_block(b4) {|k, v| v * 2}

  c = Proc.new {|arg| arg + 1}
  puts (arrays[0].my_map_proc_block(c)).inspect
  puts (arrays[1].my_map_proc_block(c)).inspect
  c2 = Proc.new {|k, v| v + 1}
  puts hashes[1].my_map_proc_block(c2)

  puts (arrays[0].my_map_proc_block {|arg2| arg2 * 2}).inspect
  puts (arrays[1].my_map_proc_block {|arg2| arg2 * 2}).inspect
  puts hashes[1].my_map_proc_block {|k, v| v * 2}

  puts "\nmy_each test\n"
  hashes[0].my_each{|k, v| print k + ": " + v + "!  "}
  puts
  hashes[1].my_each{|k, v| print k.to_s + ": " + v.to_s + "!  "}
  puts
  arrays[0].my_each{|v| print v.to_s + "!  "}
  puts
  arrays[1].my_each{|v| print v.to_s + "!  "}
  puts
  arrays[2].my_each{|v| print v + "!  "}
  puts

  puts "\nmy_select test\n"
  puts (hashes[0].my_select{|k, v| v == "Fevereiro"}).inspect
  puts (hashes[1].my_select{|k, v| v>10}).inspect
  puts (arrays[0].my_select{|v| v>3}).inspect
  puts (arrays[1].my_select{|v| v%2 == 0}).inspect
  puts (arrays[2].my_select{|v| v == "we"}).inspect
 

  puts "\nmy_all? test\n"
  puts (hashes[0].my_all? {|k, v| v != "marco"}).inspect
  puts (hashes[0].my_all? {|k, v| v != "Fevereiro"}).inspect
  puts (hashes[1].my_all? {|k, v| v>10}).inspect
  puts (hashes[1].my_all? {|k, v| v>0}).inspect
  puts (arrays[0].my_all? {|v| v>3}).inspect
  puts (arrays[0].my_all? {|v| v<300}).inspect
  puts (arrays[1].my_all? {|v| v%2 == 0}).inspect
  puts (arrays[1].my_all? {|v| v> 0}).inspect
  puts (arrays[2].my_all? {|v| v == "we"}).inspect
  puts (arrays[2].my_all? {|v| v != "w"}).inspect

  puts "\nmy_any? test\n"
  puts (hashes[0].my_any? {|k, v| v == "marco"}).inspect
  puts (hashes[0].my_any? {|k, v| v == "Fevereiro"}).inspect
  puts (hashes[1].my_any? {|k, v| v>10}).inspect
  puts (hashes[1].my_any? {|k, v| v>0}).inspect
  puts (arrays[0].my_any? {|v| v>4}).inspect
  puts (arrays[0].my_any? {|v| v<2}).inspect
  puts (arrays[1].my_any? {|v| v == 0}).inspect
  puts (arrays[1].my_any? {|v| v> 4}).inspect
  puts (arrays[2].my_any? {|v| v == "w"}).inspect
  puts (arrays[2].my_any? {|v| v != "we"}).inspect


  puts "\nmy_none? test\n"
  puts (hashes[0].my_none? {|k, v| v == "marco"}).inspect
  puts (hashes[0].my_none? {|k, v| v == "Fevereiro"}).inspect
  puts (hashes[1].my_none? {|k, v| v>10}).inspect
  puts (hashes[1].my_none? {|k, v| v>0}).inspect
  puts (hashes[1].my_none? {|k, v| v>100}).inspect
  puts (arrays[0].my_none? {|v| v>4}).inspect
  puts (arrays[0].my_none? {|v| v<2}).inspect
  puts (arrays[1].my_none? {|v| v == 0}).inspect
  puts (arrays[1].my_none? {|v| v> 4}).inspect
  puts (arrays[2].my_none? {|v| v == "w"}).inspect
  puts (arrays[2].my_none? {|v| v != "we"}).inspect

  puts "\nmy_count test\n"
  puts (hashes[0].my_count {|k, v| v == "marco"}).inspect
  puts (hashes[0].my_count {|k, v| v != "marco"}).inspect
  puts (hashes[0].my_count {|k, v| v == "Fevereiro"}).inspect
  puts (hashes[1].my_count {|k, v| v>10}).inspect
  puts (hashes[1].my_count {|k, v| v>0}).inspect
  puts (hashes[1].my_count {|k, v| v>100}).inspect
  puts (arrays[0].my_count {|v| v>4}).inspect
  puts (arrays[0].my_count {|v| v<2}).inspect
  puts (arrays[1].my_count {|v| v == 0}).inspect
  puts (arrays[1].my_count {|v| v> 4}).inspect
  puts (arrays[2].my_count {|v| v == "w"}).inspect
  puts (arrays[2].my_count {|v| v != "we"}).inspect

  puts "\nmy_map test\n"
  puts hashes[0].my_map {|k, v| v = "marco"}.inspect
  puts hashes[0].my_map {|k, v| v = "mes de "+v}.inspect
  puts hashes[0].my_map {|k, v| v = "Abril"}.inspect
  puts hashes[1].my_map {|k, v| v*10}.inspect
  puts hashes[1].my_map {|k, v| v*0}.inspect
  puts hashes[1].my_map {|k, v| v+2}.inspect
  puts arrays[0].my_map {|v| v*4}.inspect
  puts arrays[0].my_map {|v| v+2}.inspect
  puts arrays[1].my_map {|v| v*2}.inspect
  puts arrays[2].my_map {|v| v = "w"}.inspect
  puts arrays[2].my_map {|v| v = v+"!"}.inspect

end



