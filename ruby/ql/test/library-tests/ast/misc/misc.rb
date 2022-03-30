bar = "bar"

undef foo, :foo, foo=, [], []=
undef :"foo_#{bar}"
undef nil, true, false, super, self

alias new :old
alias foo= []=
alias super self
alias :"\n#{bar}" :"foo"
