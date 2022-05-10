import importlib
import re
import pytest

# Create your tests here.

def discover_save_tests():
    mod = importlib.import_module("testapp.orm_tests")
    test_names = []

    for name in dir(mod):
        m = re.match("test_(save.*)_load", name)
        if not m:
            continue
        name = m.group(1)
        test_names.append(name)

    return test_names

def discover_load_tests():
    mod = importlib.import_module("testapp.orm_tests")
    test_names = []

    for name in dir(mod):
        m = re.match("test_(load.*)", name)
        if not m:
            continue
        name = m.group(1)
        if name == "load_init":
            continue
        test_names.append(name)

    return test_names

@pytest.mark.django_db
@pytest.mark.parametrize("name", discover_save_tests())
def test_run_save_tests(name):
    mod = importlib.import_module("testapp.orm_tests")

    init_func = getattr(mod, f"test_{name}_init", None)
    store_func = getattr(mod, f"test_{name}_store", None)
    load_func = getattr(mod, f"test_{name}_load", None)

    if init_func:
        init_func()
    store_func()
    load_func()

has_run_load_init = False

@pytest.fixture
def load_test_init():
    from .orm_tests import test_load_init
    test_load_init()


@pytest.mark.django_db
@pytest.mark.parametrize("name", discover_load_tests())
def test_run_load_tests(load_test_init, name):
    mod = importlib.import_module("testapp.orm_tests")

    load_func = getattr(mod, f"test_{name}", None)
    load_func()

    assert getattr(mod, "TestLoad").objects.count() == 10

@pytest.mark.django_db
def test_mymodel_form_save():
    from .orm_form_test import MyModel, MyModelForm
    import uuid
    text = str(uuid.uuid4())
    form = MyModelForm(data={"text": text})
    form.save()

    obj = MyModel.objects.last()
    assert obj.text == text

@pytest.mark.django_db
def test_none_all():
    from .orm_form_test import MyModel
    MyModel.objects.create(text="foo")

    assert len(MyModel.objects.all()) == 1
    assert len(MyModel.objects.none().all()) == 0
    assert len(MyModel.objects.all().none()) == 0


@pytest.mark.django_db
def test_orm_inheritance():
    from .orm_inheritance import (save_physical_book, save_ebook, save_base_book,
        fetch_book, fetch_physical_book, fetch_ebook,
        PhysicalBook, EBook,
    )

    base = save_base_book()
    physical = save_physical_book()
    ebook = save_ebook()

    fetch_book(base.id)
    fetch_book(physical.id)
    fetch_book(ebook.id)

    fetch_physical_book(physical.id)
    fetch_ebook(ebook.id)

    try:
        fetch_physical_book(base.id)
    except PhysicalBook.DoesNotExist:
        pass

    try:
        fetch_ebook(ebook.id)
    except EBook.DoesNotExist:
        pass


@pytest.mark.django_db
def test_poly_orm_inheritance():
    from .orm_inheritance import (poly_save_physical_book, poly_save_ebook, poly_save_base_book,
        poly_fetch_book, poly_fetch_physical_book, poly_fetch_ebook,
        PolyPhysicalBook, PolyEBook,
    )

    base = poly_save_base_book()
    physical = poly_save_physical_book()
    ebook = poly_save_ebook()

    poly_fetch_book(base.id, test_for_subclass=False)
    poly_fetch_book(physical.id)
    poly_fetch_book(ebook.id)

    poly_fetch_physical_book(physical.id)
    poly_fetch_ebook(ebook.id)

    try:
        poly_fetch_physical_book(base.id)
    except PolyPhysicalBook.DoesNotExist:
        pass

    try:
        poly_fetch_ebook(ebook.id)
    except PolyEBook.DoesNotExist:
        pass
