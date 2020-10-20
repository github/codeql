from django.db import connection, models
from django.db.models.expressions import RawSQL


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

class User(models.Model):
    pass

def test_model(username):
    # GOOD -- Using parameters
    User.objects.raw("SELECT * FROM users WHERE username = %s", (username,))  # $getSql="SELECT * FROM users WHERE username = %s"

    # BAD -- other ways of executing raw SQL code with string interpolation
    User.objects.annotate(RawSQL("insert into names_file ('name') values ('%s')" % username))  # $getSql=BinaryExpr
    User.objects.raw("insert into names_file ('name') values ('%s')" % username)  # $getSql=BinaryExpr
    User.objects.extra("insert into names_file ('name') values ('%s')" % username)  # $getSql=BinaryExpr
