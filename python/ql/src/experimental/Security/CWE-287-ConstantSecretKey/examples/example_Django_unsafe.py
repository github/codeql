import sys
import environ
from django.conf import settings
from django.conf import global_settings
from django.urls import path
from django.http import HttpResponse

env = environ.Env(
    SECRET_KEY=(str, "AConstantKey")
)
env.read_env(env_file='.env')
# following is not safe if there is default value in Env(..)
settings.SECRET_KEY = env('SECRET_KEY')

settings.configure(
    DEBUG=True,
    SECRET_KEY="constant1",
    ROOT_URLCONF=__name__,
)
global_settings.SECRET_KEY = "constant2"
settings.SECRET_KEY = "constant3"


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
