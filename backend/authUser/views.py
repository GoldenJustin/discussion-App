from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from .serializer import UserSerializer
from django.contrib.auth import authenticate, login, logout
from .token import get_user_token
from .models import User


# from random import randint

# Create your views here.

@api_view(["POST", "GET"])
@permission_classes([AllowAny])
def RegisterUser(request):
    print(request.data)
    if request.method == "POST":
        data = request.data
        print(request.data)
        username = data['username']
        # user = None
        user = User.objects.filter(username=username)
        if user:
            message = {'message': 'user does exist'}
            return Response(message)

        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            # user_id = User.objects.get(username=username)
            message = {'save': True}
            return Response(message)
        else:
            message = {'save': False}
            return Response(message)
    return Response({'message': "hey bro"})


# {
#     "username":"mike",
#     "email":"mike@gmail.com",
#     "password":"123",
#     "phone":"0693331836"
# }

@api_view(["POST"])
@permission_classes([AllowAny])
def LoginView(request):
    print(request.data)
    username = request.data.get('username')
    password = request.data.get('password')
    user = authenticate(username=username, password=password)

    if user is not None:
        login(request, user)
        user_id = User.objects.values('id', 'email', 'username', 'phone').get(
            username=username)

        response = {
            'user': user_id,
            'msg': 'success',
            'token': get_user_token(user),
        }
        return Response(response)
    else:
        response = {
            'msg': 'Fail',
            'reason': 'Invalid username or password'
        }

        return Response(response)

# {
#     "username": "mike",
#     "password": "123"
# }

