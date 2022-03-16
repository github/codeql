The interesting ORM tests files can be found under `testapp/orm_*.py`. These are set up to be executed by the [testapp/tests.py](testapp/tests.py) file.

List of interesting tests files (that might go out of date if it is forgotten :flushed:):

- [testapp/orm_tests.py](testapp/orm_tests.py): which tests flow from source to sink
- [testapp/orm_form_test.py](testapp/orm_form_test.py): shows how forms can be used to save Models to the DB
- [testapp/orm_security_tests.py](testapp/orm_security_tests.py): which highlights some interesting interactions with security queries
- [testapp/orm_inheritance.py](testapp/orm_inheritance.py): which highlights how inheritance of ORM models works

## Setup

```
pip install django pytest pytest-django django-polymorphic
```

## Run server

```
python manage.py makemigrations && python manage.py migrate && python manage.py runserver
```

## Run tests

```
pytest
```
