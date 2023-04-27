class FooController < ActionController::Base
  def some_request_handler
    # A source for the data-flow query (i.e. a remote flow source)
    name = params[:name]

    # A vulnerable regex
    regex = /^\s+|\s+$/

    # Various sinks that match the source against the regex
    name =~ regex         # NOT GOOD
    name !~ regex         # NOT GOOD
    name[regex]           # NOT GOOD
    name.gsub regex, ''   # NOT GOOD
    name.index regex      # NOT GOOD
    name.match regex      # NOT GOOD
    name.match? regex     # NOT GOOD
    name.partition regex  # NOT GOOD
    name.rindex regex     # NOT GOOD
    name.rpartition regex # NOT GOOD
    name.scan regex       # NOT GOOD
    name.split regex      # NOT GOOD
    name.sub regex, ''    # NOT GOOD
    regex.match name      # NOT GOOD
    regex.match? name     # NOT GOOD

    # Destructive variants
    a = params[:b]
    a.gsub! regex, ''     # NOT GOOD
    b = params[:a]
    b.slice! regex        # NOT GOOD
    c = params[:c]
    c.sub! regex, ''      # NOT GOOD

    # GOOD - guarded by a string length check
    if name.length < 1024
      name.gsub regex, ''
    end

    # GOOD - regex does not suffer from polynomial backtracking (regression test)
    params[:foo] =~ /\A[bc].*\Z/

    case name # NOT GOOD
    when regex 
      puts "foo"
    end

    case name # NOT GOOD
    in /^\s+|\s+$/ then 
      puts "foo"
    end
  end

  def some_other_request_handle
    name = params[:name] # source

    indirect_use_of_reg /^\s+|\s+$/, name

    as_string_indirect '^\s+|\s+$', name
  end

  def indirect_use_of_reg (reg, input)
    input.gsub reg, '' # NOT GOOD
  end

  def as_string_indirect (reg_as_string, input)
    input.match? reg_as_string, '' # NOT GOOD
  end

  def re_compile_indirect 
    name = params[:name] # source

    reg = Regexp.new '^\s+|\s+$'
    re_compile_indirect_2 reg, name
  end

  def re_compile_indirect_2 (reg, input)
    input.gsub reg, '' # NOT GOOD
  end
end
