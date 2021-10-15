def double_heredoc
  puts(<<A, <<A)
    hello
A
   world
A
end
