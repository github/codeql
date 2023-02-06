import uuid


class User:
    def __init__(self):
        self.token = None

    def resetPassword(self):
        self.token = uuid.uuid1().hex


user = User()
user.resetPassword()
