# boolean values and nil
nil
NIL
false
FALSE
true
TRUE

# decimal integers
1234
5_678
0
0d900
2147483647 # max value representable by QL's int type
2147483648 # too large to be representable by an int

# hexadecimal integers
0x1234
0xbeef
0xF0_0D
0x000000000000000000ff
0x7FFF_FFFF # max value representable by QL's int type
0x80000000  # too large to be represented by an int
0xdeadbeef  # too large to be represented by an int
0xF00D_face # too large to be represented by an int

# octal integers
0123
0o234
0O45_6
0000000000000000000000000000010
017777777777 # max value representable by QL's int type
020000000000 # too large to be represented by an int

# binary integers
0b10010100
0B011_01101
0b00000000000000000000000000000000000000011
0b01111111111111111111111111111111 # max value representable by QL's int type
0b10000000000000000000000000000000 # too large to be represented by an int

# floating-point numbers
12.34
1234e-2
1.234E1

# rational numbers
23r
9.85r

# imaginary/complex numbers
2i
#3.14i # BAD: parse error

# imaginary & rational
#1.2ri # BAD: parse error

# strings
""
''
"hello"
'goodbye'
"string with escaped \" quote"
'string with " quote'
%(foo bar baz)
%q<foo bar baz>
%q(foo ' bar " baz')
%Q(FOO ' BAR " BAZ')
%q(foo\ bar)                # "foo\\ bar"
%Q(foo\ bar)                # "foo bar"
"2 + 2 = #{ 2 + 2 }"        # interpolation
%Q(3 + 4 = #{ 3 + 4 })      # interpolation
'2 + 2 = #{ 2 + 2 }'        # no interpolation
%q(3 + 4 = #{ 3 + 4 })      # no interpolation
"foo" 'bar' "baz"           # concatenated
%q{foo} "bar" 'baz'         # concatenated
"foo" "bar#{ 1 * 1 }" 'baz' # concatenated, interpolation
"foo #{ "bar #{ 2 + 3 } baz" } qux" # interpolation containing string containing interpolation
"foo #{ blah(); 1+9 }"      # multiple statements in interpolation
bar = "bar"
BAR = "bar"
"foo #{ bar }"              # local variables in interpolation
"foo #{ BAR }"              # constants in interpolation

# characters
?x
?\n
?\s
?\\
?\u{58}
?\C-a
?\M-a
?\M-\C-a
?\C-\M-a

# symbols
:""
:hello
:"foo bar"
:'bar baz'
{ foo: "bar" }
%s(wibble)
%s[wibble wobble]
:"foo_#{ 2 + 2}_#{bar}_#{BAR}"   # interpolation
:'foo_#{ 2 + 2}_#{bar}_#{BAR}'   # no interpolation
%s(foo_#{ 3 - 2 }) # no interpolation

# arrays
[]
[1, 2, 3]
[4, 5, 12 / 2]
[7, [8, 9]]

# arrays of strings
%w()
%w(foo bar baz)
%w!foo bar baz!
%W[foo bar#{1+1} #{bar} #{BAR} baz] # interpolation
%w[foo bar#{1+1} #{bar} #{BAR} baz] # no interpolation

# arrays of symbols
%i()
%i(foo bar baz)
%i@foo bar baz@
%I(foo bar#{ 2 + 4 } #{bar} #{BAR} baz) # interpolation
%i(foo bar#{ 2 + 4 } #{bar} #{BAR} baz) # no interpolation

# hashes
{}
{ foo: 1, :bar => 2, 'baz' => 3 }
{ foo: 7, **baz } # hash-splat argument

# ranges
(1..10)
(1...10)
(1 .. 0)
(start..2+3)
(1..) # 1 to infinity
(..1) # -infinity to 1
(0..-1) # BAD: parsed as binary with minus endless range on the LHS

# subshell
`ls -l`
%x(ls -l)
`du -d #{ 1 + 1 } #{bar} #{BAR}`   # interpolation
%x@du -d #{ 5 - 4 }@               # interpolation

# regular expressions
//
/foo/
/foo/i
/foo+\sbar\S/
/foo#{ 1 + 1 }bar#{bar}#{BAR}/    # interpolation
/foo/oxm
%r[]
%r(foo)
%r:foo:i
%r{foo+\sbar\S}
%r{foo#{ 1 + 1 }bar#{bar}#{BAR}}  # interpolation
%r:foo:mxo

# long strings
'abcdefghijklmnopqrstuvwxyzabcdef'  # 32 chars, should not be truncated
'foobarfoobarfoobarfoobarfoobarfoo' # 33 chars, should be truncated
"foobar\\foobar\\foobar\\foobar\\foobar" # several short components, but long enough overall to be truncated

# here documents
run_sql(<<SQL, <<SQL)
select * from table
SQL
where name = #{ name }
SQL

def m 
  query = <<-BLA
some text\nand some more
  BLA
end

query = <<~SQUIGGLY
   indented stuff
SQUIGGLY

query = <<"DOC"
 text with #{ interpolation } !
DOC

# TODO: the parser currently does not handle single quoted heredocs correctly
query = <<'DOC'
 text without #{ interpolation } !
DOC

output = <<`SCRIPT`
 cat file.txt
SCRIPT

x = 42
{x:, y:5}
{y: , Z:}