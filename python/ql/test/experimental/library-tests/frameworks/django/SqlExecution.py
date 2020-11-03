from django.db import connection, models
from django.db.models.expressions import RawSQL


def test_plain():
    cursor = connection.cursor()
    cursor.execute("some sql")  # $getSql="some sql"


def test_context():
    with connection.cursor() as cursor:
        cursor.execute("some sql")  # $getSql="some sql"
        cursor.execute(sql="some sql")  # $getSql="some sql"


class User(models.Model):
    pass


def test_model():
    User.objects.raw("some sql")  # $getSql="some sql"
    User.objects.annotate(RawSQL("some sql"))  # $getSql="some sql"
    User.objects.annotate(RawSQL("foo"), RawSQL("bar"))  # $getSql="foo" getSql="bar"
    User.objects.annotate(val=RawSQL("some sql"))  # $getSql="some sql"
    User.objects.extra("some sql")  # $getSql="some sql"
    User.objects.extra(select="select", where="where", tables="tables", order_by="order_by")  # $getSql="select" getSql="where" getSql="tables" getSql="order_by"

    raw = RawSQL("so raw")
    User.objects.annotate(val=raw)  # $getSql="so raw"
