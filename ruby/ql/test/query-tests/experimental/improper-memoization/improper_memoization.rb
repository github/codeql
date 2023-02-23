# GOOD - Should not trigger CodeQL rule

# No arguments passed to method
def m1
  @m1 ||= long_running_method
end

# No arguments passed to method
def m2
  @m2 ||= begin
    long_running_method
  end
end

# OK: argument used in key.
# May be incorrect if arg is `false` or `nil`.
def m3(arg)
  @m3 ||= {}
  @m3[arg] ||= long_running_method(arg)
end

# OK: both arguments used in key.
# May be incorrect if either arg is `false` or `nil`.
def m4(arg1, arg2)
  @m4 ||= {}
  @m4[[arg1, arg2]] ||= result(arg1, arg2)
end

# OK: argument used in key.
# Still correct if arg is `false` or `nil`.
def m5(arg)
  @m5 ||= Hash.new do |h1, key|
    h1[key] = long_running_method(key)
  end
  @m5[arg]
end

# OK: both arguments used in key.
# Still correct if either arg is `false` or `nil`.
def m6(arg1, arg2)
  @m6 ||= Hash.new do |h1, arg1|
    h1[arg1] = Hash.new do |h2, arg2|
      h2[arg2] = result(arg1, arg2)
    end
  end
  @m6[arg1][arg2]
end

# Bad: method has parameter but only one result is memoized.
def m7(arg)
  @m7 ||= begin
    arg += 3
  end
  @m7
end # $result=BAD

# Bad: method has parameter but only one result is memoized.
def m8(arg)
  @m8 ||= begin
    long_running_method(arg)
  end
  @m8
end # $result=BAD

# Bad: method has parameter but only one result is memoized.
def m9(arg)
  @m9 ||= long_running_method(arg)
end # $result=BAD

# Bad: method has parameter but only one result is memoized.
def m10(arg1, arg2)
  @m10 ||= long_running_method(arg1, arg2)
end # $result=BAD

# Bad: `arg2` not used in key.
def m11(arg1, arg2)
  @m11 ||= {}
  @m11[arg1] ||= long_running_method(arg1, arg2)
end # $result=BAD

# Bad: `arg2` not used in key.
def m12(arg1, arg2)
  @m12 ||= Hash.new do |h1, arg1|
    h1[arg1] = result(arg1, arg2)
  end
  @m12[arg1]
end # $result=BAD

# Bad: arg not used in key.
def m13(id:)
  @m13 ||= Rails.cache.fetch("product_sku/#{id}", expires_in: 30.minutes) do
    ActiveRecord::Base.transaction do
      ProductSku.find_by(id: id)
    end
  end
  @m13
end # $result=BAD

# Good (FP): arg is used in key via string interpolation.
def m14(arg)
  @m14 ||= {}
  key = "foo/#{arg}"
  @m14[key] ||= long_running_method(arg)
end