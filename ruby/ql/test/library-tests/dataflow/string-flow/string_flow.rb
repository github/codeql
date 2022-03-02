def m_new
    a = source "a"
    sink String.new(a) # $ hasValueFlow=a
end

def m_try_convert
    a = source "a"
    b = source 1
    sink String.try_convert(a) # $ hasTaintFlow=a
    sink String.try_convert(b) # $ hasTaintFlow=1
end

def m_format
    a = source "a"
    sink "%s" % a # $ hasTaintFlow=a
    sink "%s %s" % ["foo", a] # $ hasTaintFlow=a
    sink a % "foo" # $ hasTaintFlow=a
end

def m_plus
    a = source "a"
    b = a + "b"
    sink b # $ hasTaintFlow=a
end

def m_mult
    a = source "a"
    b = a * 5
    sink b # $ hasTaintFlow=a
end

def m_push
    a = source "a"
    b = a << "b"
    sink b # $ hasTaintFlow=a
    c = "c" << a
    sink c # $ hasTaintFlow=a
end

def m_b
    a = source "a"
    sink a.b # $ hasTaintFlow=a
end

def m_byteslice
    a = source "a"
    sink a.byteslice(1) # $ hasTaintFlow=a
    sink a.byteslice(1, 2) # $ hasTaintFlow=a
    sink a.byteslice(1..2) # $ hasTaintFlow=a
end

def m_capitalize
    a = source "a"
    sink a.capitalize # $ hasTaintFlow=a
    sink a.capitalize! # $ hasTaintFlow=a
end

def m_center
    a = source "a"
    sink a.center(10) # $ hasTaintFlow=a
    sink "foo".center(10, a) # $ hasTaintFlow=a
    sink a.ljust(10) # $ hasTaintFlow=a
    sink "foo".ljust(10, a) # $ hasTaintFlow=a
    sink a.rjust(10) # $ hasTaintFlow=a
    sink "foo".rjust(10, a) # $ hasTaintFlow=a
end

def m_chomp
    a = source "a"
    sink a.chomp # $ hasTaintFlow=a
    sink a.chomp! # $ hasTaintFlow=a
end

def m_chomp
    a = source "a"
    sink a.chop # $ hasTaintFlow=a
    sink a.chop! # $ hasTaintFlow=a
end

# TODO: this currently doesn't work because the flow summary for Array#clear
# only clears array content.
def m_clear
    a = source "a"
    a.clear
    sink a
end

# concat and prepend omitted because they clash with the summaries for
# Array#concat and Array#prepend.
#
# def m_concat
#     a = source "a"
#     b = source "b"
#     c = "c"
#     sink c.concat(a, b) # $ hasValueFlow=a hasValueFlow=b
#     sink c # $ hasValueFlow=a hasValueFlow=b
# end

# def m_prepend
#     a = source "a"
#     b = source "b"
#     c = "c"
#     sink c.prepend(a, b) # $ hasValueFlow=a hasValueFlow=b
#     sink c # $ hasValueFlow=a hasValueFlow=b
# end

def m_delete
    a = source "a"
    sink a.delete("b") # $ hasTaintFlow=a
    sink a.delete_prefix("b") # $ hasTaintFlow=a
    sink a.delete_suffix("b") # $ hasTaintFlow=a
end

def m_downcase
    a = source "a"
    sink a.downcase # $ hasTaintFlow=a
    sink a.downcase! # $ hasTaintFlow=a
    sink a.swapcase # $ hasTaintFlow=a
    sink a.swapcase! # $ hasTaintFlow=a
    sink a.upcase # $ hasTaintFlow=a
    sink a.upcase! # $ hasTaintFlow=a
end

def m_dump
    a = source "a"
    b = a.dump
    sink b # $ hasTaintFlow=a
    sink b.undump # $ hasTaintFlow=a
end

def m_each_line
    a = source "a"
    b = a.each_line { |line| sink line } # $ hasTaintFlow=a
    sink b # $ hasTaintFlow=a
    c = a.each_line
    sink c.to_a[0] # $ hasTaintFlow=a
end

def m_lines
    a = source "a"
    b = a.lines { |line| sink line } # $ hasTaintFlow=a
    sink b # $ hasTaintFlow=a
    c = a.lines
    sink c[0] # $ hasTaintFlow=a
end

def m_encode
    a = source "a"
    sink a.encode("ASCII") # $ hasTaintFlow=a
    sink a.encode!("ASCII") # $ hasTaintFlow=a
    sink a.unicode_normalize # $ hasTaintFlow=a
    sink a.unicode_normalize! # $ hasTaintFlow=a
end

def m_force_encoding
    a = source "a"
    sink a.force_encoding("ASCII") # $ hasTaintFlow=a
end

def m_freeze
    a = source "a"
    sink a.freeze # $ hasTaintFlow=a
end

def m_gsub
    a = source "a"
    c = source "c"
    sink a.gsub("b", c) # $ hasTaintFlow=a hasTaintFlow=c
    sink a.gsub!("b", c) # $ hasTaintFlow=a hasTaintFlow=c
    sink a.gsub("b") { |match| source "b" } # $ hasTaintFlow=a hasTaintFlow=b
    sink a.gsub!("b") { |match| source "b" } # $ hasTaintFlow=a hasTaintFlow=b
end

def m_sub
    a = source "a"
    c = source "c"
    sink a.sub("b", c) # $ hasTaintFlow=a hasTaintFlow=c
    sink a.sub!("b", c) # $ hasTaintFlow=a hasTaintFlow=c
    sink a.sub("b") { |match| source "b" } # $ hasTaintFlow=a hasTaintFlow=b
    sink a.sub!("b") { |match| source "b" } # $ hasTaintFlow=a hasTaintFlow=b
end

# omitted because it clashes with the summary for Array#insert
# def m_insert
#     a = source "a"
#     sink a.insert(1, "c") # $ hasTaintFlow=a
#     sink "c".insert(1, a) # $ hasValueFlow=a
# end

def m_inspect
    a = source "a"
    sink a.inspect # $ hasTaintFlow=a
end

def m_strip
    a = source "a"
    sink a.strip # $ hasTaintFlow=a
    sink a.strip! # $ hasTaintFlow=a
    sink a.lstrip # $ hasTaintFlow=a
    sink a.lstrip! # $ hasTaintFlow=a
    sink a.rstrip # $ hasTaintFlow=a
    sink a.rstrip! # $ hasTaintFlow=a
end

def m_next
    a = source "a"
    sink a.next # $ hasTaintFlow=a
    sink a.next! # $ hasTaintFlow=a
    sink a.succ # $ hasTaintFlow=a
    sink a.succ! # $ hasTaintFlow=a
end

def m_partition
    a = source "a"
    b = a.partition("b")
    sink b[0] # $ hasTaintFlow=a
    sink b[1] # $ hasTaintFlow=a
    sink b[2] # $ hasTaintFlow=a
    sink b[3]
end

def m_replace
    a = source "a"
    b = source "b"
    sink a.replace(b) # $ hasTaintFlow=b
    # TODO: currently we get value flow for a, because we don't clear content
    sink a # $ hasTaintFlow=b
end

def m_reverse
    a = source "a"
    sink a.reverse # $ hasTaintFlow=a
end

def m_scan(i)
    a = source "a"
    b = a.scan(/b/) { |x, y| sink x } # $ hasTaintFlow=a
    b = a.scan(/b/) { |x, y| sink y } # $ hasTaintFlow=a
    sink b # $ hasTaintFlow=a
    b = a.scan(/b/)
    sink b[0] # $ hasTaintFlow=a
    sink b[i] # $ hasTaintFlow=a
end

def m_scrub
    a = source "a"
    sink a.scrub("b") # $ hasTaintFlow=a
    sink "b".scrub(a) # $ hasTaintFlow=a
    a.scrub { |x| sink x } # $ hasTaintFlow=a
    sink("b".scrub { |x| a }) # $ hasTaintFlow=a

    sink a.scrub!("b") # $ hasTaintFlow=a
    sink "b".scrub!(a) # $ hasTaintFlow=a

    a = source "a"
    a.scrub! { |x| sink x } # $ hasTaintFlow=a

    sink("b".scrub! { |x| a }) # $ hasTaintFlow=a
end

def m_shellescape
    a = source "a"
    sink a.shellescape # $ hasTaintFlow=a
end

def m_shellsplit(i)
    a = source "a"
    b = a.shellsplit
    sink b[i] # $ hasTaintFlow=a
end

def m_slice(i)
    a = source "a"
    b = a.slice(1)
    sink b[i] # $ hasTaintFlow=a

    b = a.slice!(1)
    sink b[i] # $ hasTaintFlow=a

    b = a.split("b")
    sink b[i] # $ hasTaintFlow=a

    b = a[1,2]
    sink b[i] # $ hasTaintFlow=a
end

def m_squeeze
    a = source "a"
    sink a.squeeze # $ hasTaintFlow=a
    sink a.squeeze("b") # $ hasTaintFlow=a
    sink a.squeeze! # $ hasTaintFlow=a
    sink a.squeeze!("b") # $ hasTaintFlow=a
end

def m_to_str
    a = source "a"
    sink a.to_str # $ hasTaintFlow=a
    sink a.to_s # $ hasTaintFlow=a
end

def m_tr
    a = source "a"
    sink a.tr("c", "d") # $ hasTaintFlow=a
    sink "b".tr("c", a) # $ hasTaintFlow=a
    sink a.tr!("c", "d") # $ hasTaintFlow=a
    sink "b".tr!("c", a) # $ hasTaintFlow=a
    sink a.tr_s("c", "d") # $ hasTaintFlow=a
    sink "b".tr_s("c", a) # $ hasTaintFlow=a
    sink a.tr_s!("c", "d") # $ hasTaintFlow=a
    sink "b".tr_s!("c", a) # $ hasTaintFlow=a
end

def m_upto(i)
    a = source "a"
    a.upto("b") { |x| sink x } # $ hasTaintFlow=a
    a.upto("b", true) { |x| sink x } # $ hasTaintFlow=a
    "b".upto(a) { |x| sink x } # $ hasTaintFlow=a
    "b".upto(a, true) { |x| sink x }
end