import django.http
from django.core.mail import send_mail, mail_admins, mail_managers


def django_response(request):
    """
      The Django.core.mail#send_mail function source code can be found in the link below:
      https://github.com/django/django/blob/ca9872905559026af82000e46cde6f7dedc897b6/django/core/mail/__init__.py#L38

      send_mass_mail does not provide html_message as an argument to it's function. See the link below for more info: 
      https://github.com/django/django/blob/ca9872905559026af82000e46cde6f7dedc897b6/django/core/mail/__init__.py#L64
      """
    send_mail("Subject", "plain-text body", "from@example.com",
              ["to@example.com"], html_message=django.http.request.GET.get("html"))


def django_response(request):
    """
    The Django.core.mail#mail_admins and Django.core.mail#mail_managers functions source code can be found in the link below:
    https://github.com/django/django/blob/ca9872905559026af82000e46cde6f7dedc897b6/django/core/mail/__init__.py#L90-L121
    """
    mail_admins("Subject", "plain-text body",
                html_message=django.http.request.GET.get("html"))
    mail_managers("Subject", "plain-text body",
                  html_message=django.http.request.GET.get("html"))
