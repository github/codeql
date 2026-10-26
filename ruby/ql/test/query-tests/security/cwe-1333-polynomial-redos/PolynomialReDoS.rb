class FooController < ActionController::Base
  def some_request_handler
    # A source for the data-flow query (i.e. a remote flow source)
    name = params[:name] # $ Source

    # A vulnerable regex
    regex = /^\s+|\s+$/

    # Various sinks that match the source against the regex
    name =~ regex # $ Alert // NOT GOOD
    name !~ regex # $ Alert // NOT GOOD
    name[regex] # $ Alert // NOT GOOD
    name.gsub regex, '' # $ Alert // NOT GOOD
    name.index regex # $ Alert // NOT GOOD
    name.match regex # $ Alert // NOT GOOD
    name.match? regex # $ Alert // NOT GOOD
    name.partition regex # $ Alert // NOT GOOD
    name.rindex regex # $ Alert // NOT GOOD
    name.rpartition regex # $ Alert // NOT GOOD
    name.scan regex # $ Alert // NOT GOOD
    name.split regex # $ Alert // NOT GOOD
    name.sub regex, '' # $ Alert // NOT GOOD
    regex.match name # $ Alert // NOT GOOD
    regex.match? name # $ Alert // NOT GOOD

    # Destructive variants
    a = params[:b] # $ Source
    a.gsub! regex, '' # $ Alert // NOT GOOD
    b = params[:a] # $ Source
    b.slice! regex # $ Alert // NOT GOOD
    c = params[:c] # $ Source
    c.sub! regex, '' # $ Alert // NOT GOOD

    # GOOD - guarded by a string length check
    if name.length < 1024
      name.gsub regex, ''
    end

    # GOOD - regex does not suffer from polynomial backtracking (regression test)
    params[:foo] =~ /\A[bc].*\Z/

    case name # $ Sink // NOT GOOD
    when regex 
      puts "foo"
    end # $ Alert

    case name # $ Sink // NOT GOOD
    in /^\s+|\s+$/ then 
      puts "foo"
    end # $ Alert
  end

  def some_other_request_handle
    name = params[:name] # $ Source // source

    indirect_use_of_reg /^\s+|\s+$/, name

    as_string_indirect '^\s+|\s+$', name
  end

  def indirect_use_of_reg (reg, input)
    input.gsub reg, '' # $ Alert // NOT GOOD
  end

  def as_string_indirect (reg_as_string, input)
    input.match? reg_as_string, '' # $ Alert // NOT GOOD
  end

  def re_compile_indirect 
    name = params[:name] # $ Source // source

    reg = Regexp.new '^\s+|\s+$'
    re_compile_indirect_2 reg, name
  end

  def re_compile_indirect_2 (reg, input)
    input.gsub reg, '' # $ Alert // NOT GOOD
  end

  # See https://github.com/dependabot/dependabot-core/blob/37dc1767fde9b7184020763f4d0c1434f93d11d6/python/lib/dependabot/python/requirement_parser.rb#L6-L25
  NAME = /[a-zA-Z0-9](?:[a-zA-Z0-9\-_\.]*[a-zA-Z0-9])?/
  EXTRA = /[a-zA-Z0-9\-_\.]+/
  COMPARISON = /===|==|>=|<=|<|>|~=|!=/
  VERSION = /([1-9][0-9]*!)?[0-9]+[a-zA-Z0-9\-_.*]*(\+[0-9a-zA-Z]+(\.[0-9a-zA-Z]+)*)?/

  REQUIREMENT = /(?<comparison>#{COMPARISON})\s*\\?\s*(?<version>#{VERSION})/
  HASH = /--hash=(?<algorithm>.*?):(?<hash>.*?)(?=\s|\\|$)/
  REQUIREMENTS = /#{REQUIREMENT}(\s*,\s*\\?\s*#{REQUIREMENT})*/
  HASHES = /#{HASH}(\s*\\?\s*#{HASH})*/
  MARKER_OP = /\s*(#{COMPARISON}|(\s*in)|(\s*not\s*in))/
  PYTHON_STR_C = %r{[a-zA-Z0-9\s\(\)\.\{\}\-_\*#:;/\?\[\]!~`@\$%\^&=\+\|<>]}
  PYTHON_STR = /('(#{PYTHON_STR_C}|")*'|"(#{PYTHON_STR_C}|')*")/
  ENV_VAR =
      /python_version|python_full_version|os_name|sys_platform|
      platform_release|platform_system|platform_version|platform_machine|
      platform_python_implementation|implementation_name|
      implementation_version/
  MARKER_VAR = /\s*(#{ENV_VAR}|#{PYTHON_STR})/
  MARKER_EXPR_ONE = /#{MARKER_VAR}#{MARKER_OP}#{MARKER_VAR}/
  MARKER_EXPR = /(#{MARKER_EXPR_ONE}|\(\s*|\s*\)|\s+and\s+|\s+or\s+)+/

  def use_marker_expr 
    name = params[:name] # $ Source // source

    name =~ MARKER_EXPR  # $ Alert
  end  
end
