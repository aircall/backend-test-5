from django.urls import path

from . import views

urlpatterns = [
    path('incoming', views.incoming, name='incoming'),
    path('gather', views.gather, name='gather'),
    path('record', views.record, name='record'),
]