# Tests for implicit return steps in Ruby data flow.
#
# An implicit return is when no `return` statement is used; instead the
# last evaluated expression is returned.
#
# The following cases test the behaviour when the returned value is
# in the main body, a `rescue` clause, or an `else` clause,
# with and without an `ensure` clause present.

# Simple implicit return from the method body.
def m_body
  source(1)
end

sink(m_body) # $ hasValueFlow=1

# Implicit return from the method body when an `ensure` clause is present.
def m_body_ensure
  source(2)
ensure
  source(20)
end

sink(m_body_ensure) # $ MISSING: hasValueFlow=2

# Implicit return from a `rescue` clause.
def m_rescue
  raise "error"
rescue
  source(3)
end

sink(m_rescue) # $ MISSING: hasValueFlow=3

# Implicit return from a `rescue` clause when an `ensure` clause is present.
def m_rescue_ensure
  raise "error"
rescue
  source(4)
ensure
  source(40)
end

sink(m_rescue_ensure) # $ MISSING: hasValueFlow=4

# Implicit return from an `else` clause.
def m_else
  source(50)
rescue
  nil
else
  source(5)
end

sink(m_else) # $ MISSING: hasValueFlow=5

# Implicit return from an `else` clause when an `ensure` clause is present.
def m_else_ensure
  source(60)
rescue
  nil
else
  source(6)
ensure
  nil
end

sink(m_else_ensure) # $ MISSING: hasValueFlow=6
