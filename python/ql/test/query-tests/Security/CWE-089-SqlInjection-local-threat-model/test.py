# test that enabling local threat-model works end-to-end
import sys
import psycopg

conn = psycopg.connect(...)
conn.execute(sys.argv[1])
