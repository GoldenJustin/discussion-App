from django.urls import path
from .views import *
# from rest_framework_simplejwt import views as jwt_views
app_name = 'app1'

urlpatterns = [
    path('create_group', CreateGroup),
    path('join_group', JoinGroup),
    path('upload_file', upload_file),
    
    path('upload-file/', upload_file),
    path('delete-file/', delete_file),
    path('download-file/<int:file_id>/', download_file),

    
    path('group_files/<int:group_id>', GroupFiles),
    path('joined_group/<int:user_id>', JoinedGroup),
    path('created_group/<int:user_id>', CreatedGroup),
    path('group_info/<int:group_id>', GroupInfo),
    path('deactivate_group/<int:group_id>', DeactivateGroup),
]


    # Upload File url
    #   http://192.168.1.161:5000/upload-file/

    # Delete File url
    #   http://192.168.1.161:5000/delete-file/

    # Download File url
    #   http://192.168.1.161:5000/download-file/<file_id>/