from django.urls import path, re_path

from . import orm_security_tests
from . import orm_form_test

urlpatterns = [
    path("person/", orm_security_tests.person),
    path("show_name/", orm_security_tests.show_name),
    path("show_age/", orm_security_tests.show_age),

    path("save_comment_validator_not_used/", orm_security_tests.save_comment_validator_not_used),
    path("display_comment_validator_not_used/", orm_security_tests.display_comment_validator_not_used),

    path("save_comment_validator_used/", orm_security_tests.save_comment_validator_used),
    path("display_comment_validator_used/", orm_security_tests.display_comment_validator_used),

    path("mymodel/add/", orm_form_test.add_mymodel_handler),
    path("mymodel/show/", orm_form_test.show_mymodel_handler),
]
