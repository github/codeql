# frozen_string_literal: true

=begin
some preprocessing here
and here
=end

class FLinesTest

    def foo(bar)
      # This is a comment
      # and another

      some_string = <<-ESCAPE
hello world
multiple
lines

how many lines of code in this heredoc?
# 9 lines total

ESCAPE

      some_other_string = "line 1
      line" + bar

      p some_string
      p some_other_string

      some_string + some_other_string
    end


end
