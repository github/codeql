import streamlit as st

# Streamlit sources
inp = st.text_input("Query the database") # $ source=st.text_input(..)
area = st.text_area("Area") # $ source=st.text_area(..)
chat = st.chat_input("Chat") # $ source=st.chat_input(..)

# Initialize connection.
conn = st.connection("postgresql", type="sql")

# SQL injection sink
q = conn.query("some sql")  # $ getSql="some sql"

# SQLAlchemy connection
c = conn.connect()

c.execute("other sql")  # $ getSql="other sql"

# SQL Alchemy session
s = conn.session

s.execute("yet another sql")  # $ getSql="yet another sql"

# SQL Alchemy engine
e = st.connection("postgresql", type="sql")

e.engine.connect().execute("yet yet another sql")  # $ getSql="yet yet another sql"
