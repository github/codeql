from django.db import models

SOURCE = "source"


def SINK(arg):
    print(arg)
    assert arg == SOURCE


def SINK_F(arg):
    print(arg)
    assert arg != SOURCE


# ==============================================================================
# Inheritance
#
# If base class defines a field, there can be
# 1. flow when field is assigned on subclass construction to lookup of base class
# 2. no flow from field assignment on subclass A to lookup of sibling subclass B
# 3. no flow from field assignment on base class to lookup of subclass
# ==============================================================================

# ------------------------------------------------------------------------------
# Inheritance with vanilla Django
# ------------------------------------------------------------------------------

class Book(models.Model):
    title = models.CharField(max_length=256)


class PhysicalBook(Book):
    physical_location = models.CharField(max_length=256)
    same_name_different_value = models.CharField(max_length=256)


class EBook(Book):
    download_link = models.CharField(max_length=256)
    same_name_different_value = models.CharField(max_length=256)


def save_base_book():
    return Book.objects.create(
        title=SOURCE,
    )


def fetch_book(id):
    book = Book.objects.get(id=id)

    try:
        # This sink should have 2 sources, from `save_base_book` and
        # `save_physical_book`
        SINK(book.title) # $ flow="SOURCE, l:-10 -> book.title" flow="SOURCE, l:+21 -> book.title"
    # The sink assertion will fail for the EBook, which we handle. The title attribute
    # of a Book could be tainted, so we want this to be a sink in general.
    except AssertionError:
        if book.title == "safe ebook":
            pass
        else:
            raise

    assert not isinstance(book, PhysicalBook)
    assert not isinstance(book, EBook)

    try:
        SINK_F(book.physical_location)
        raise Exception("This field is not available with vanilla Django")
    except AttributeError:
        pass


def save_physical_book():
    return PhysicalBook.objects.create(
        title=SOURCE,
        physical_location=SOURCE,
        same_name_different_value=SOURCE,
    )


def fetch_physical_book(id):
    book = PhysicalBook.objects.get(id=id)

    # This sink should have only 1 sources, from `save_physical_book`
    SINK(book.title) # $ flow="SOURCE, l:-10 -> book.title"
    SINK(book.physical_location) # $ flow="SOURCE, l:-10 -> book.physical_location"
    SINK(book.same_name_different_value) # $ flow="SOURCE, l:-10 -> book.same_name_different_value"


def save_ebook():
        return EBook.objects.create(
        title="safe ebook",
        download_link="safe",
        same_name_different_value="safe",
    )


def fetch_ebook(id):
    book = EBook.objects.get(id=id)

    SINK_F(book.title)
    SINK_F(book.download_link)
    SINK_F(book.same_name_different_value)


# ------------------------------------------------------------------------------
# Inheritance with `django-polymorphic`, which automatically turns lookups on the
# base class into the right subclass
#
# see https://django-polymorphic.readthedocs.io/en/stable/quickstart.html
# ------------------------------------------------------------------------------

from polymorphic.models import PolymorphicModel


class PolyBook(PolymorphicModel):
    title = models.CharField(max_length=256)


class PolyPhysicalBook(PolyBook):
    physical_location = models.CharField(max_length=256)
    same_name_different_value = models.CharField(max_length=256)


class PolyEBook(PolyBook):
    download_link = models.CharField(max_length=256)
    same_name_different_value = models.CharField(max_length=256)


def poly_save_base_book():
    return PolyBook.objects.create(
        title=SOURCE
    )


def poly_fetch_book(id, test_for_subclass=True):
    book = PolyBook.objects.get(id=id)

    try:
        # This sink should have 2 sources, from `poly_save_base_book` and
        # `poly_save_physical_book`
        SINK(book.title) # $ flow="SOURCE, l:-10 -> book.title" flow="SOURCE, l:+24 -> book.title"
    # The sink assertion will fail for the PolyEBook, which we handle. The title
    # attribute of a PolyBook could be tainted, so we want this to be a sink in general.
    except AssertionError:
        if book.title == "safe ebook":
            pass
        else:
            raise

    if test_for_subclass:
        assert isinstance(book, PolyPhysicalBook) or isinstance(book, PolyEBook)

    if isinstance(book, PolyPhysicalBook):
        SINK(book.title) # $ flow="SOURCE, l:+11 -> book.title" SPURIOUS: flow="SOURCE, l:-23 -> book.title"
        SINK(book.physical_location) # $ flow="SOURCE, l:+11 -> book.physical_location"
        SINK(book.same_name_different_value) # $ flow="SOURCE, l:+11 -> book.same_name_different_value"
    elif isinstance(book, PolyEBook):
        SINK_F(book.title) # $ SPURIOUS: flow="SOURCE, l:-27 -> book.title" flow="SOURCE, l:+7 -> book.title"
        SINK_F(book.download_link)
        SINK_F(book.same_name_different_value) # $ SPURIOUS: flow="SOURCE, l:+7 -> book.same_name_different_value"


def poly_save_physical_book():
    return PolyPhysicalBook.objects.create(
        title=SOURCE,
        physical_location=SOURCE,
        same_name_different_value=SOURCE,
    )


def poly_fetch_physical_book(id):
    book = PolyPhysicalBook.objects.get(id=id)

    SINK(book.title) # $ flow="SOURCE, l:-9 -> book.title"
    SINK(book.physical_location) # $ flow="SOURCE, l:-9 -> book.physical_location"
    SINK(book.same_name_different_value) # $ flow="SOURCE, l:-9 -> book.same_name_different_value"


def poly_save_ebook():
        return PolyEBook.objects.create(
        title="safe ebook",
        download_link="safe",
        same_name_different_value="safe",
    )


def poly_fetch_ebook(id):
    book = PolyEBook.objects.get(id=id)

    SINK_F(book.title)
    SINK_F(book.download_link)
    SINK_F(book.same_name_different_value)
