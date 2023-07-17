from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.

class User(AbstractUser):
    USERNAME_FIELD = "username"
    phone = models.CharField(max_length=10)

    def __str__(self):
        return self.username

    class Meta:
        db_table = 'user'

