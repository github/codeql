from django.db import connection, models


def test_plain(username):
    # GOOD -- Using parameters
    connection.cursor().execute("SELECT * FROM users WHERE username = %s", username)  # $getSql="SELECT * FROM users WHERE username = %s"

    # BAD -- Using string formatting
    connection.cursor().execute("SELECT * FROM users WHERE username = '%s'" % username)  # $getSql=BinaryExpr


def test_context(username):
    with connection.cursor() as cursor:
        # GOOD -- Using parameters
        cursor.execute("SELECT * FROM users WHERE username = %s", username)  # $getSql="SELECT * FROM users WHERE username = %s"

        # BAD -- Using string formatting
        cursor.execute("SELECT * FROM users WHERE username = '%s'" % username)  # $getSql=BinaryExpr
