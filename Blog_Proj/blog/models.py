from django.db import models
from django.utils import timezone
from django.contrib.auth.models import User
from django.urls import reverse

# Create your models here.


class Post(models.Model):
    title = models.CharField(max_length=100)
    content = models.TextField()
    date_posted = models.DateTimeField(default=timezone.now)
    # .now is a function, but don't want to execute here
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    # if you delete a User, their posts will be deleted too
    # this will return an object as opposed to a string, so, can access attributes of that object like email from posts

    def __str__(self):
        return self.title

    # method to define redirect after creating a post
    # returns path to any instance
    def get_absolute_url(self):
        return reverse("post-detail", kwargs={"pk": self.pk})
        # redirect will take you to a specific route
        # reverse returns full path to a route, as a string
