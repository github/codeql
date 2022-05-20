# see https://docs.djangoproject.com/en/1.11/_modules/django/shortcuts/#redirect
# https://github.com/django/django/blob/86908785076b2bbc31b908781da6b6ad1779b18b/django/shortcuts.py

def render(request, template_name, context=None, content_type=None, status=None, using=None):
    pass

def redirect(to, *args, **kwargs):
    pass
