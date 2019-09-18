from django.conf.urls import url
import views

urlpatterns = [

    url(r'^route1$', views.view_func1),
    url(r'^(?P<path>.*)$', views.view_func2),
    url(r'^route2$', views.ClassView.as_view())
]
