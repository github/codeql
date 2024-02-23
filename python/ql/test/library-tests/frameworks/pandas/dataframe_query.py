import pandas as pd


df = pd.DataFrame({'temp_c': [17.0, 25.0]}, index=['Portland', 'Berkeley'])
df.sample().query("query")  # $getCode="query"
df.mod().query("query")   # $getCode="query"
pd.eval("pythonExpr", target=df)  # $getCode="pythonExpr"

df = pd.read_csv("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"
df.copy().query("query")  # $getCode="query"

df = pd.read_fwf("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"


df = pd.read_pickle("filepath")  # $ decodeInput="filepath" decodeOutput=pd.read_pickle(..) decodeFormat=pickle decodeMayExecuteInput
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_table("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_clipboard("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_excel("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_html("filepath")
df[0].query("query")  # $getCode="query"

df = pd.read_xml("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_parquet("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_orc("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_spss("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_sql_table("filepath", 'postgres:///db_name')
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_sql_query("filepath", 'postgres:///db_name')
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_sql("filepath", 'postgres:///db_name')
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_gbq("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_stata("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"

df = pd.read_sas("filepath")
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"
df = pd.read_sas("filepath", iterator=True, chunksize=1)
df.query("query")
df = pd.read_sas("filepath", iterator=False, chunksize=1)
df.query("query")
df = pd.read_sas("filepath", iterator=True, chunksize=None)
df.query("query")
df = pd.read_sas("filepath", iterator=False, chunksize=None)
df.query("query")  # $getCode="query"
df.eval("query")  # $getCode="query"
