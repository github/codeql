import pandas

df = pandas.DataFrame({'a': [1, 2, 3], 'b': [4, 5, 6]})
df.query("cmd") # $getCode="cmd"
df.query(expr="cmd") # $getCode="cmd"

df.eval("cmd") # $getCode="cmd"
df.eval(expr="cmd") # $getCode="cmd"
