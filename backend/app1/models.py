from django.db import models
from authUser.models import User
# Create your models here.


class Group(models.Model):
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=10, unique=True, null=True)
    description = models.TextField()
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f'{self.name} with code {self.code}'

    class Meta:
        db_table = 'group'


class GroupUser(models.Model):
    group_id = models.ForeignKey(Group, on_delete=models.CASCADE)
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.group_id.name} has {self.user_id.username}'

    class Meta:
        db_table = 'group_user'


class File(models.Model):
    book = models.FileField(upload_to="uploaded/", )
    group_id = models.ForeignKey(Group, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.group_id.name}'

    class Meta:
        db_table = 'file'

