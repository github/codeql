module Foo 
  def bar(x) 
    # Run the /a+$/ regex on the input x.
    match = x.match(/a+$/)
  end

  protected
    def baz(x)
      match = x.match(/a+$/)

      match2 = x.match(/(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)C.*Y$/)
    end
end