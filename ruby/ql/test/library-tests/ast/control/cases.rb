# Define some variables used below
a = 0
b = 0
c = 0
d = 0

# A case expr with a value and an else branch
case a
when b
    100
when c, d
    200
else
    300
end

# A case expr without a value or else branch
case
when a > b  then 10
when a == b then 20
when a < b  then 30
end

# pattern matching

case expr
  in 5 then true
  else false
end

case expr
  in x unless x < 0
  then true
  in x if x < 0
  then true
  else false
end

case expr
  in 5
  in 5, 
  in 1, 2 
  in 1, 2, 
  in 1, 2, 3 
  in 1, 2, 3, 
  in 1, 2, 3, * 
  in 1, *x, 3 
  in * 
  in *, 3, 4 
  in *, 3, * 
  in *a, 3, *b 
  in a: 
  in a: 5 
  in a: 5, 
  in a: 5, b:, ** 
  in a: 5, b:, **map 
  in a: 5, b:, **nil 
  in **nil 
  in [5] 
  in [5,] 
  in [1, 2] 
  in [1, 2,] 
  in [1, 2, 3] 
  in [1, 2, 3,] 
  in [1, 2, 3, *] 
  in [1, *x, 3] 
  in [*] 
  in [*x, 3, 4] 
  in [*, 3, *] 
  in [*a, 3, *b] 
  in {a:} 
  in {a: 5} 
  in {a: 5,} 
  in {a: 5, b:, **} 
  in {a: 5, b:, **map} 
  in {a: 5, b:, **nil} 
  in {**nil} 
  in {} 
  in [] 
end

# more pattern matching 

foo = 42

case expr 
  in 5
  in ^foo
  in "string"
  in %w(foo bar)
  in %i(foo bar)
  in /.*abc[0-9]/
  in 5 .. 10
  in .. 10
  in 5 ..
  in 5 => x
  in Foo
  in Foo::Bar
  in ::Foo::Bar
  in nil | self | true | false | __LINE__ | __FILE__ | __ENCODING__
  in -> x { x == 10 }
  in :foo
  in :"foo bar"
  in -5 | +10
  in (1 ..)
  in (0 | "" | [] | {})
  in var
end

case expr 
  in 5 | ^foo | "string" | var
end

# array patterns

case expr 
  in [];
  in [x];
  in [x, ];
  in Foo::Bar[];
  in Foo();
  in Bar(*);
  in Bar(a, b, *c, d, e);
end

# find patterns

case expr 
  in [*, x, *];
  in [*x, 1, 2, *y];
  in Foo::Bar[*, 1, *];
  in Foo(*, Bar, *);
end

# hash patterns

case expr 
  in {};
  in {x:};
  in Foo::Bar[ x:1 ];
  in Foo::Bar[ x:1, a:, **rest ];
  in Foo( y:);
  in Bar( ** );
  in Bar( a: 1, **nil);
end

case expr 
  in ^foo;
  in ^$foo;
  in ^@foo;
  in ^@@foo;
end

case expr 
  in ^(foo);
  in ^(@foo);
  in ^(1 + 1);
end

expr in [1, 2]

expr => {x: v, y: 1}

case 
  foo
when 1 then 2
end

case
  foo
in 3 then "three"
end