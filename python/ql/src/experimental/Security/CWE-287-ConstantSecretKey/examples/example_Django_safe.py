import sys

from django.conf import settings
from django.conf import global_settings
from django.urls import path
from django.http import HttpResponse
from django.core.management.utils import get_random_secret_key

settings.configure(
    DEBUG=True,
    SECRET_KEY=get_random_secret_key(),
    ROOT_URLCONF=__name__,
)
global_settings.SECRET_KEY = get_random_secret_key()
settings.SECRET_KEY = get_random_secret_key()


def home(request):
    return HttpResponse(settings.SECRET_KEY)


urlpatterns = [
    path("", home),
]

if __name__ == "__main__":
    from django.core.management import execute_from_command_line

    if len(sys.argv) == 1:
        sys.argv.append("runserver")
        sys.argv.append("8080")
    execute_from_command_line(sys.argv)
