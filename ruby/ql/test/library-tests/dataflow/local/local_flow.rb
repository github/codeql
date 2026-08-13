# Tests local value flow through Ruby expressions. Each source and sink occurs
# in one callable, so no interprocedural flow is needed.

def assignments
  simple = source("simple assignment")
  sink(simple)

  chained = also_chained = source("chained assignment")
  sink(chained)
  sink(also_chained)

  parenthesized = (source("parenthesized assignment"))
  sink(parenthesized)

  augmented = source("augmented assignment")
  augmented += 1
  sink(augmented)

  conditional_or = nil
  conditional_or ||= source("or assignment")
  sink(conditional_or)

  conditional_and = source("and assignment")
  conditional_and &&= source("and assignment rhs")
  sink(conditional_and)
end

def conditionals
  if_value =
    if true
      source("if")
    else
      nil
    end
  sink(if_value)

  unless_value =
    unless false
      source("unless")
    else
      nil
    end
  sink(unless_value)

  ternary_value = true ? source("ternary") : nil
  sink(ternary_value)

  or_value = source("logical or") || nil
  sink(or_value)

  and_value = true && source("logical and")
  sink(and_value)

  keyword_or_value = (source("keyword or") or nil)
  sink(keyword_or_value)

  keyword_and_value = (true and source("keyword and"))
  sink(keyword_and_value)
end

def case_expressions(value)
  when_value =
    case value
    when 0
      source("when")
    else
      nil
    end
  sink(when_value)

  pattern_value =
    case value
    in 0
      source("pattern")
    else
      nil
    end
  sink(pattern_value)
end

def loops
  while_value = while true
    break source("while break")
  end
  sink(while_value)

  until_value = until false
    break source("until break")
  end
  sink(until_value)

  for_value = for _ in [1]
    break source("for break")
  end
  sink(for_value)
end

def begin_expressions
  begin_value = begin
    source("begin")
  end
  sink(begin_value)

  rescue_value = begin
    raise StandardError
  rescue StandardError
    source("rescue")
  end
  sink(rescue_value)
end

module LocalFlowModule
  module_value = source("module body")
  sink(module_value)
end

class LocalFlowClass
  class_value = source("class body")
  sink(class_value)
end
