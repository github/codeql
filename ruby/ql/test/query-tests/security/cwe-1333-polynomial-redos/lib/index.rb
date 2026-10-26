module Foo 
  def bar(x)  # $ Source
    # Run the /a+$/ regex on the input x.
    match = x.match(/a+$/) # $ Alert
  end

  protected
    def baz(x) # $ Source
      match = x.match(/a+$/) # $ Alert

      match2 = x.match(/(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)(AA|BB)C.*Y$/) # $ Alert
    end
end
