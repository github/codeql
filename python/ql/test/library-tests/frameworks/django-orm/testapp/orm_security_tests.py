"""
Handling of ORM steps that are only relevant to real taint-tracking queries, and not core dataflow.
"""

from django.db import models
from django.http.response import HttpResponse

# ------------------------------------------------------------------------------
# Some fields are not relevant for some security queries
# ------------------------------------------------------------------------------

# TODO: We need some way to mark that a certain data-flow node can only contain
# an integer, so it can be excluded from queries.

class Person(models.Model):
    name = models.CharField(max_length=256)
    age = models.IntegerField()

def person(request):
    if request.method == "POST":
        person = Person()
        person.name = request.POST["name"]
        person.age = request.POST["age"]

        # at this point, `person.age` is a string, and could contain anything
        assert isinstance(person.age, str)

        person.save()

        # after saving, there will be an error if the string could not be converted to an integer.
        # the attribute on the local object is not changed (so still `str`) but after fetching from DB it is
        # an `int`
        assert isinstance(person.age, str)

        # after doing `.full_clean` it also has the proper data-type
        person.full_clean()
        assert isinstance(person.age, int)

        return HttpResponse("ok")
    elif request.method == "GET":
        resp_text = "<h1>Persons:</h1>"
        for person in Person.objects.all():
            resp_text += "\n{} (age {})".format(person.name, person.age)
        return HttpResponse(resp_text)  # NOT OK

def show_name(request):
    person = Person.objects.get(id=request.GET["id"])
    return HttpResponse("Name is: {}".format(person.name))  # NOT OK

def show_age(request):
    person = Person.objects.get(id=request.GET["id"])
    assert isinstance(person.age, int)

    # Since the age is an integer, there is not actually XSS in the line below
    return HttpResponse("Age is: {}".format(person.age))  # OK

# look at the log after doing
"""
http -f 'http://127.0.0.1:8000/person/' name="foo" age=42
http 'http://127.0.0.1:8000/show_age/?id=1'
"""

# ------------------------------------------------------------------------------
# Custom validators on fields
# ------------------------------------------------------------------------------
#
# We currently do not include these in any of our queries. There are two reasons:
#
# 1. We don't have any good way to determine what the validator actually does. So we
#    don't have any way to determine if a validator would make data safe for a
#    particular query. So we would have to blindly trust that if any validator was
#    specified, that would mean data is always safe :| We still want to produce more
#    results, so by default, we would want to do it this way, and live live with the FPs
#    that arise -- if it turns out that is too troublesome, we can look more into it.
#
# 2. Using a validator on the input data does not make any guarantees on the data that
#    is already in the DB. It's better to perform escaping on the data as part of
#    outputing/rendering, since you know _all_ data will be escaped, and that the right
#    kind of escaping is applied (there is a difference in what needs to be escaped for
#    different vulnerabilities, so doing validation that rejects things that would cause
#    XSS might still accept things that can do SQL injection)


from django.core.exceptions import ValidationError
import re

def only_az(value):
    if not re.match(r"^[a-zA-Z]$", value):
        raise ValidationError("only a-zA-Z allowed")

# First example: Validator is set, but not used
class CommentValidatorNotUsed(models.Model):
    text = models.CharField(max_length=256, validators=[only_az])

def save_comment_validator_not_used(request): # $requestHandler
    comment = CommentValidatorNotUsed(text=request.POST["text"])
    comment.save()
    return HttpResponse("ok")

def display_comment_validator_not_used(request): # $requestHandler
    comment = CommentValidatorNotUsed.objects.last()
    return HttpResponse(comment.text)  # NOT OK

# To test this
"""
http -f http://127.0.0.1:8000/save_comment_validator_not_used/ text="foo!@#"
http http://127.0.0.1:8000/display_comment_validator_not_used/
"""

# Second example: Validator is set, AND is used
class CommentValidatorUsed(models.Model):
    text = models.CharField(max_length=256, validators=[only_az])

def save_comment_validator_used(request): # $requestHandler
    comment = CommentValidatorUsed(text=request.POST["text"])
    comment.full_clean()
    comment.save()

def display_comment_validator_used(request): # $requestHandler
    comment = CommentValidatorUsed.objects.last()
    return HttpResponse(comment.text)  # sort of OK

# Doing the following will raise a ValidationError
"""
http -f http://127.0.0.1:8000/save_comment_validator_used/ text="foo!@#"
"""
