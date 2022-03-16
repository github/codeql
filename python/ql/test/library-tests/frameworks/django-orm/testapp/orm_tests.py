from django.db import models


SOURCE = "source"


def SINK(arg):
    print(arg)
    assert arg == SOURCE


def SINK_F(arg):
    print(arg)
    assert arg != SOURCE

# ------------------------------------------------------------------------------
# Different ways to save data to the DB through ORM
#
# These tests are set up with their own individual model, so it's possible to see
# whether the source works or not (although there is quite a bit of boilerplate). The
# problem with using the same model multiple times, is that it won't be obvious if the
# single SINK call actually has flow from all the expected places or not.
# ------------------------------------------------------------------------------

# --------------------------------------
# Constructor: kw arg
# --------------------------------------
class TestSave1(models.Model):
    text = models.CharField(max_length=512)

def test_save1_store():
    obj = TestSave1(text=SOURCE)
    obj.save()

def test_save1_load():
    obj = TestSave1.objects.first()
    SINK(obj.text) # $ flow="SOURCE, l:-5 -> obj.text"

# --------------------------------------
# Constructor: positional arg
# --------------------------------------
class TestSave2(models.Model):
    text = models.CharField(max_length=512)

def test_save2_store():
    # first positional argument is `id`, a primary key automatically added
    # see https://docs.djangoproject.com/en/4.0/topics/db/models/#automatic-primary-key-fields
    obj = TestSave2(None, SOURCE)
    obj.save()

def test_save2_load():
    obj = TestSave2.objects.first()
    SINK(obj.text) # $ MISSING: flow

# --------------------------------------
# Constructor: positional arg, with own primary key
# --------------------------------------
class TestSave3(models.Model):
    text = models.CharField(max_length=512, primary_key=True)

def test_save3_store():
    # no `id` column added, see https://docs.djangoproject.com/en/4.0/topics/db/models/#automatic-primary-key-fields
    obj = TestSave3(SOURCE)
    obj.save()

def test_save3_load():
    obj = TestSave3.objects.first()
    SINK(obj.text) # $ MISSING: flow

# --------------------------------------
# Set attribute on fresh object
# --------------------------------------
class TestSave4(models.Model):
    text = models.CharField(max_length=512)

def test_save4_store():
    obj = TestSave4()
    obj.text = SOURCE
    obj.save()

def test_save4_load():
    obj = TestSave4.objects.first()
    SINK(obj.text) # $ flow="SOURCE, l:-5 -> obj.text"

# --------------------------------------
# Set attribute on existing
# --------------------------------------

class TestSave4b(models.Model):
    text = models.CharField(max_length=512)

def test_save4b_init():
    obj = TestSave4b()
    obj.text = "foo"
    obj.save()

def test_save4b_store():
    obj = TestSave4b.objects.first()
    obj.text = SOURCE
    obj.save()

def test_save4b_load():
    obj = TestSave4b.objects.first()
    SINK(obj.text) # $ flow="SOURCE, l:-5 -> obj.text"

# --------------------------------------
# <Model>.objects.create()
# see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#create
# --------------------------------------
class TestSave5(models.Model):
    text = models.CharField(max_length=512)

def test_save5_store():
    # note: positional args not possible
    obj = TestSave5.objects.create(text=SOURCE)
    SINK(obj.text) # $ flow="SOURCE, l:-1 -> obj.text"

def test_save5_load():
    obj = TestSave5.objects.first()
    SINK(obj.text) # $ flow="SOURCE, l:-5 -> obj.text"

# --------------------------------------
# <Model>.objects.get_or_create()
# see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#get-or-create
# --------------------------------------
class TestSave6(models.Model):
    text = models.CharField(max_length=512)
    email = models.CharField(max_length=256)

def test_save6_store():
    obj, _created = TestSave6.objects.get_or_create(defaults={"text": SOURCE}, email=SOURCE)
    SINK(obj.text) # $ MISSING: flow
    SINK(obj.email) # $ MISSING: flow

def test_save6_load():
    obj = TestSave6.objects.first()
    SINK(obj.text) # $ MISSING: flow
    SINK(obj.email) # $ flow="SOURCE, l:-7 -> obj.email"

# --------------------------------------
# <Model>.objects.update_or_create()
# see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#update-or-create
# --------------------------------------
class TestSave7(models.Model):
    text = models.CharField(max_length=512)
    email = models.CharField(max_length=256)

def test_save7_store():
    obj, _created = TestSave7.objects.update_or_create(defaults={"text": SOURCE}, email=SOURCE)
    SINK(obj.text) # $ MISSING: flow
    SINK(obj.email) # $ MISSING: flow

def test_save7_load():
    obj = TestSave7.objects.first()
    SINK(obj.text) # $ MISSING: flow
    SINK(obj.email) # $ flow="SOURCE, l:-7 -> obj.email"

# --------------------------------------
# <Model>.objects.[<QuerySet>].update()
# --------------------------------------
class TestSave8(models.Model):
    text = models.CharField(max_length=512)

def test_save8_init():
    TestSave8.objects.create(text="foo")

def test_save8_store():
    _updated_count = TestSave8.objects.all().update(text=SOURCE)

def test_save8_load():
    obj = TestSave8.objects.first()
    SINK(obj.text) # $ flow="SOURCE, l:-4 -> obj.text"

# --------------------------------------
# .save() on foreign key field
# --------------------------------------
class TestSave9(models.Model):
    text = models.CharField(max_length=512)

class TestSave9WithForeignKey(models.Model):
    test = models.ForeignKey(TestSave9, models.deletion.CASCADE)

def test_save9_init():
    obj = TestSave9.objects.create(text="foo")
    TestSave9WithForeignKey.objects.create(test=obj)

def test_save9_store():
    w_fk = TestSave9WithForeignKey.objects.first()
    w_fk.test.text = SOURCE
    w_fk.test.save()
    # note that `w_fk.save()` does NOT save the state of the `TestSave9` object.

def test_save9_load():
    obj = TestSave9.objects.first()
    SINK(obj.text) # $ MISSING: flow

# --------------------------------------
# foreign key backreference (auto-generated name)
# see https://docs.djangoproject.com/en/4.0/topics/db/queries/#following-relationships-backward
# --------------------------------------

class save10_BlogPost(models.Model):
    # dummy content, only has automatic `id` field
    pass

class save10_Comment(models.Model):
    text = models.CharField(max_length=512)
    blog = models.ForeignKey(save10_BlogPost, models.deletion.CASCADE)

def test_save10_init():
    blogpost = save10_BlogPost.objects.create()
    save10_Comment.objects.create(blog=blogpost, text="foo")

def test_save10_store():
    blogpost = save10_BlogPost.objects.first()
    for comment in blogpost.save10_comment_set.all():
        comment.text = SOURCE
        comment.save()

def test_save10_load():
    obj = save10_Comment.objects.first()
    SINK(obj.text) # $ MISSING: flow

# --------------------------------------
# foreign key backreference, with custom name
# see https://docs.djangoproject.com/en/4.0/topics/db/queries/#following-relationships-backward
# --------------------------------------

class save11_BlogPost(models.Model):
    # dummy contet, only has automatic `id` field
    pass

class save11_Comment(models.Model):
    text = models.CharField(max_length=512)
    blog = models.ForeignKey(save11_BlogPost, models.deletion.CASCADE, related_name="comments")

def test_save11_init():
    blogpost = save11_BlogPost.objects.create()
    save11_Comment.objects.create(blog=blogpost, text="foo")

def test_save11_store():
    blogpost = save11_BlogPost.objects.first()
    for comment in blogpost.comments.all():
        comment.text = SOURCE
        comment.save()

def test_save11_load():
    obj = save11_Comment.objects.first()
    SINK(obj.text) # $ MISSING: flow

# --------------------------------------
# <Model>.objects.bulk_create()
# see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#bulk-create
# --------------------------------------
class TestSave12(models.Model):
    text = models.CharField(max_length=512)

def test_save12_store():
    objs = TestSave12.objects.bulk_create([
        TestSave12(text=SOURCE),
        TestSave12(text="foo"),
    ])
    SINK(objs[0].text) # $ MISSING: flow

def test_save12_load():
    obj = TestSave12.objects.first()
    SINK(obj.text) # $ MISSING: flow

# --------------------------------------
# <Model>.objects.bulk_update()
# see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#bulk-update
# --------------------------------------
class TestSave13(models.Model):
    text = models.CharField(max_length=512)

def test_save13_init():
    obj = TestSave13(text="foo")
    obj.save()

def test_save13_store():
    objs = TestSave13.objects.all()
    for obj in objs:
        obj.text = SOURCE
    TestSave13.objects.bulk_update(objs, ["text"])

def test_save13_load():
    obj = TestSave13.objects.first()
    SINK(obj.text) # $ MISSING: flow

# ------------------------------------------------------------------------------
# Different ways to load data from the DB through the ORM
# ------------------------------------------------------------------------------

class TestLoad(models.Model):
    text = models.CharField(max_length=512)

def test_load_init():
    for _ in range(10):
        obj = TestLoad()
        obj.text = SOURCE
        obj.save()

def test_load_single():
    obj = TestLoad.objects.get(id=1)
    SINK(obj.text) # $ flow="SOURCE, l:-5 -> obj.text"

def test_load_many():
    objs = TestLoad.objects.all()
    for obj in objs:
        SINK(obj.text) # $ flow="SOURCE, l:-10 -> obj.text"
    SINK(objs[0].text) # $ flow="SOURCE, l:-11 -> objs[0].text"

def test_load_many_skip():
    objs = TestLoad.objects.all()[5:]
    for obj in objs:
        SINK(obj.text) # $ MISSING: flow
    SINK(objs[0].text) # $ MISSING: flow

def test_load_qs_chain_single():
    obj = TestLoad.objects.all().filter(text__contains="s").exclude(text=None).first()
    SINK(obj.text) # $ flow="SOURCE, l:-21 -> obj.text"

def test_load_qs_chain_many():
    objs = TestLoad.objects.all().filter(text__contains="s").exclude(text=None)
    for obj in objs:
        SINK(obj.text) # $ flow="SOURCE, l:-26 -> obj.text"
    SINK(objs[0].text) # $ flow="SOURCE, l:-27 -> objs[0].text"

def test_load_values():
    # see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#django.db.models.query.QuerySet.values
    vals = TestLoad.objects.all().values()
    for val in vals:
        SINK(val['text']) # $ MISSING: flow
    SINK(vals[0]['text']) # $ MISSING: flow

    # only selecting some of the fields
    vals = TestLoad.objects.all().values("text")
    for val in vals:
        SINK(val['text']) # $ MISSING: flow
    SINK(vals[0]['text']) # $ MISSING: flow

def test_load_values_list():
    # see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#django.db.models.query.QuerySet.values_list
    vals = TestLoad.objects.all().values_list()
    for (_id, text) in vals:
        SINK(text) # $ MISSING: flow
    SINK(vals[0][1]) # $ MISSING: flow

    # only selecting some of the fields
    vals = TestLoad.objects.all().values_list("text")
    for (text,) in vals:
        SINK(text) # $ MISSING: flow
    SINK(vals[0][0]) # $ MISSING: flow

    # with flat=True, each row will not be a tuple, but just the value
    vals = TestLoad.objects.all().values_list("text", flat=True)
    for text in vals:
        SINK(text) # $ MISSING: flow
    SINK(vals[0]) # $ MISSING: flow

def test_load_in_bulk():
    # see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#in-bulk
    d = TestLoad.objects.in_bulk([1])
    for val in d.values():
        SINK(val.text) # $ MISSING: flow
    SINK(d[1].text) # $ flow="SOURCE, l:-66 -> d[1].text"


# Good resources:
# - https://docs.djangoproject.com/en/4.0/topics/db/queries/#making-queries
# - https://docs.djangoproject.com/en/4.0/ref/models/querysets/
# - https://docs.djangoproject.com/en/4.0/ref/models/instances/
