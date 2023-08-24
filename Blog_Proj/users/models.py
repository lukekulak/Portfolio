from django.db import models
from django.contrib.auth.models import User
from PIL import Image

# Create your models here.


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    # if user is deleted, delete the profile. not inverse
    image = models.ImageField(default="default.jpg", upload_to="profile_pics")

    def __str__(self):
        return f"{self.user.username}'s Profile"

    # overwrite .save() method to add functionality
    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)  # runs parent class save method

        img = Image.open(self.image.path)

        if img.height > 200 or img.width > 200:
            output_size = (200, 200)
            img.thumbnail(output_size)
            img.save(self.image.path)  # save to above path to overwite original image
