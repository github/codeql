# frozen_string_literal: true

class FLinesTest

    def foo
      # This is a comment
      # and another

      some_string = <<-ESCAPE
hello world
multiple
lines

how many lines of code in this heredoc?
# 9 lines total

ESCAPE

      p some_string

      7
    end


end
