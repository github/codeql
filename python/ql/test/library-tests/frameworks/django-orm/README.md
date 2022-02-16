The main test files are:

- [testapp/orm_tests.py](testapp/orm_tests.py): which tests flow from source to sink
- [testapp/orm_security_tests.py](testapp/orm_form_test.py): shows how forms can be used to save Models to the DB
- [testapp/orm_security_tests.py](testapp/orm_security_tests.py): which highlights some interesting interactions with security queries

## Setup

```
pip install django pytest pytest-django
```

## Run server

```
python manage.py makemigrations && python manage.py migrate && python manage.py runserver
```

## Run tests

```
pytest
```
