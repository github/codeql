from mcp.server.auth.middleware.auth_context import get_access_token
from mcp.server.auth.provider import TokenVerifier


class Verifier(TokenVerifier):
    async def verify_token(self, token): # $ mad-source__remote=token
        return token


class NotAVerifier:
    async def verify_token(self, token):
        return token


def session():
    return get_access_token().token # $ mad-source__remote=get_access_token().token
