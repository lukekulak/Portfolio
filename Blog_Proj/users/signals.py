from django.db.models.signals import post_save
from django.contrib.auth.models import User
from django.dispatch import receiver
from .models import Profile

# want profile to be created for each new user


@receiver(post_save, sender=User) # when user is saved, send p_s signal, will be received by create_profile function
def create_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)

@receiver(post_save, sender=User) 
def save_profile(sender, instance, **kwargs):
    instance.profile.save()