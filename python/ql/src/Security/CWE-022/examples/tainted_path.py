import os.path


urlpatterns = [
    # Route to user_picture
    url(r'^user-pic1$', user_picture1, name='user-picture1'),
    url(r'^user-pic2$', user_picture2, name='user-picture2'),
    url(r'^user-pic3$', user_picture3, name='user-picture3')
]


def user_picture1(request):
    """A view that is vulnerable to malicious file access."""
    filename = request.GET.get('p')
    # BAD: This could read any file on the file system
    data = open(filename, 'rb').read()
    return HttpResponse(data)

def user_picture2(request):
    """A view that is vulnerable to malicious file access."""
    base_path = '/server/static/images'
    filename = request.GET.get('p')
    # BAD: This could still read any file on the file system
    data = open(os.path.join(base_path, filename), 'rb').read()
    return HttpResponse(data)

def user_picture3(request):
    """A view that is not vulnerable to malicious file access."""
    base_path = '/server/static/images'
    filename = request.GET.get('p')
    #GOOD -- Verify with normalised version of path
    fullpath = os.path.normpath(os.path.join(base_path, filename))
    if not fullpath.startswith(base_path):
        raise SecurityException()
    data = open(fullpath, 'rb').read()
    return HttpResponse(data)
