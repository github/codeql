# Examples using psycopg2 connection pools.

import psycopg2
from psycopg2.pool import SimpleConnectionPool, AbstractConnectionPool


DSN = "dbname=test user=test password=test host=localhost port=5432"


def run_simple_pool_query():
    pool = SimpleConnectionPool(1, 4, dsn=DSN)
    try:
        conn = pool.getconn()
        try:
            cur = conn.cursor()
            try:
                # Simple, parameterless query
                cur.execute("SELECT 1") # $ getSql="SELECT 1"
                _ = cur.fetchall() if hasattr(cur, "fetchall") else None # $ threatModelSource[database]=cur.fetchall()
            finally:
                cur.close()
        finally:
            pool.putconn(conn)
    finally:
        pool.closeall()


class LocalPool(AbstractConnectionPool):
    pass


def run_custom_pool_query():
    pool = LocalPool(1, 3, dsn=DSN)
    try:
        conn = pool.getconn()
        try:
            cur = conn.cursor()
            try:
                cur.execute("SELECT 2") # $ getSql="SELECT 2"
                _ = cur.fetchone() if hasattr(cur, "fetchone") else None # $ threatModelSource[database]=cur.fetchone()
            finally:
                cur.close()
        finally:
            pool.putconn(conn)
    finally:
        pool.closeall()
