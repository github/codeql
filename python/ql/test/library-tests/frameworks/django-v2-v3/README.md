Tests for Django in version 2.x and 3.x.

This folder contains a runable django application generated with `django-admin startproject testproj` and `django-admin startapp testapp`.

To run the development server, install django (in venv), and run `python manage.py runserver`

To understand how things work, see
- https://docs.djangoproject.com/en/3.1/intro/tutorial01/#creating-a-project
- https://docs.djangoproject.com/en/3.1/intro/tutorial02/#activating-models

---

Note that from [Django 2.0 only Python 3 is supported](https://docs.djangoproject.com/en/stable/releases/2.0/#python-compatibility) (enforced by `options` file).

As I see it, from a QL modeling perspective, the important part of [Django 3.0](https://docs.djangoproject.com/en/stable/releases/3.0/) was the added support for ASGI (Asynchronous Server Gateway Interface), and [Django 3.1](https://docs.djangoproject.com/en/stable/releases/3.1/) added support for async views, async middleware.

We currently don't have any tests specific to Django 3.0, since it's very compatible with Django 2.0 in general, but we could split the tests in the future.
