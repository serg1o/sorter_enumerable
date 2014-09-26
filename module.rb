#!/usr/bin/ruby

module Enumerable
 
  def my_each
    return self.to_enum if !block_given?
    i = 0
    while i < self.size
      yield(self[i])
      i += 1
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
    aux = []
    self.my_each do |a|
      aux.push(a) if yield(a)
    end
    aux
  end

  def my_all?
    return self.to_enum if !block_given?
    self.my_each do |a|
      return false if !yield(a)
    end
    true
  end    

  def my_any?
    return self.to_enum if !block_given?
    self.my_each do |a|
      return true if yield(a)
    end
    false
  end

  def my_none?
    return self.to_enum if !block_given?
    self.my_each do |a|
      return false if yield(a)
    end
    true
  end

  def my_count
    return self.to_enum if !block_given?
    total = 0
    self.my_each do |a|
      total += 1 if yield(a)
    end
    total
  end

  def my_map
    return self.to_enum if !block_given?
    aux = []
    self.my_each do |a|
      aux.push(yield(a))
    end
    aux
  end

  def my_map_proc(&proc)
    return self.to_enum if !block_given?
    aux = []
    self.my_each do |a|
      aux.push(proc.call(a))
    end
    aux
  end

  def my_map_proc_block(bloc = nil)
    return self.to_enum if (!block_given? && bloc.nil?)
    aux = []
    if (block_given? && !bloc.nil?)
      self.my_each do |a|
        aux.push(bloc.call(yield(a)))
      end
    elsif !bloc.nil?
      self.my_each do |a|
        aux.push(bloc.call(a))
      end
    end
    aux
  end

  def my_inject(init_val)
    return self.to_enum if !block_given?
    total = init_val
    self.my_each do |a|
      total = yield(total, a)
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
  b = Proc.new {|arg| print "#{arg}! "}
  ["we","erg","fg"].my_map_proc(&b)
end

def test2
  b = Proc.new {|arg| arg + 1}
  [2,3,4].my_map_proc_block(b) do |arg2|
     arg2 * 2
  end
end

def test3
  c = Proc.new {|arg| arg + 1}
  [5,6,7].my_map_proc_block(c)
end

def test4
  [10,11,12].my_map_proc_block {|arg2| arg2 * 2}
end

