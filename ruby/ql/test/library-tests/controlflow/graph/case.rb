def if_in_case
  case x1
    when 1 then (if x2 then puts "x2" end)
    when 2 then puts "2"
  end
end

def case_match value
  case value
    in 0 
    in 1 then 3
    in 2
      4
    in x if x == 5 then 6
    in x unless x < 0 then 7
    else 8
  end
end

def case_match_no_match value
  case value
    in 1
  end
end

def case_match_raise value
  case value
   in -> x { raise "oops"  }
  end
end

def case_match_array value
  case value
    in [];
    in [x];
    in [x, ];
    in Bar(a, b, *c, d, e);
  end
end

def case_match_find value
  case value 
    in [*x, 1, 2, *y];
  end
end

def case_match_hash value
  case value
    in Foo::Bar[ x:1, a:, **rest ];
    in Bar( a: 1, **nil);
    in Bar( ** );
  end
end

def case_match_variable value
  case value 
    in 5
    in var
    in "unreachable"
  end
end

def case_match_underscore value
  case value 
    in 5 | _ | "unreachable"
  end
end

def case_match_various value
  foo = 42

  case value 
    in 5
    in ^foo
    in "string"
    in %w(foo bar)
    in %i(foo bar)
    in /.*abc[0-9]/
    in 5 .. 10
    in .. 10
    in 5 ..
    in 5 => x then 1
    in 5 | ^foo | "string"
    in ::Foo::Bar
    in -> x { x == 10 }
    in :foo
    in :"foo bar"
    in -5 | +10
    in nil | self | true | false | __LINE__ | __FILE__ | __ENCODING__
    in (1 ..)
    in (0 | "" | [] | {})
  end
end

def case_match_guard_no_else value
  case value
    in x if x == 5 then 6
  end
end
