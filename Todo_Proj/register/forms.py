from django import forms
from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User


class RegisterForm(UserCreationForm):
    email = forms.EmailField()

    # below allows changing parent class properties
    # defining that RegisterForm will save into Users DB
    class Meta:
        model = User  # defining that User model will be changed when saving
        fields = ["username", "email", "password1", "password2"]
        # 0, 1, 2 are from parent class
