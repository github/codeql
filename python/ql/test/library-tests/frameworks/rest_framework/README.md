See README for `django-v2-v3` which described how the project was set up.

Since this test project uses models (and a DB), you generally need to run there 3 commands:

```
python manage.py makemigrations
python manage.py migrate
python manage.py runserver
```

Then visit http://127.0.0.1:8000/

# References

- https://www.django-rest-framework.org/tutorial/quickstart/

# Editing data

To edit data you should add an admin user (will prompt for password)

```
python manage.py createsuperuser --email admin@example.com --username admin
```
