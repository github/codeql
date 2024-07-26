import streamlit as st

# Streamlit sources
inp = st.text_input("Query the database") # $ source=st.text_input(..)
area = st.text_area("Area") # $ source=st.text_area(..)
chat = st.chat_input("Chat") # $ source=st.chat_input(..)

# Initialize connection.
conn = st.connection("postgresql", type="sql")

# SQL injection sink
q = conn.query("some sql")  # $ getSql="some sql"
