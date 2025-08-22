from cassandra.cluster import Cluster

cluster = Cluster(...)
session = cluster.connect()

session.execute("sql") # $ getSql="sql"

future = session.execute_async("sql") # $ constructedSql="sql"
future.result()

prepared = session.prepare("sql") # $ constructedSql="sql"
session.execute(prepared) # $ SPURIOUS: getSql=prepared
