from ctypes import CDLL, POINTER, Structure, byref
from ctypes import c_char_p, c_int
from ctypes.util import find_library


class PamHandle(Structure):
    pass


class PamMessage(Structure):
    pass


class PamResponse(Structure):
    pass


class PamConv(Structure):
    pass

# this is normal way to do things
libpam = CDLL(find_library("pam"))

# but we also handle assignment to temp variable
temp = find_library("pam")
libpam = CDLL(temp)

pam_start = libpam.pam_start
pam_start.restype = c_int
pam_start.argtypes = [c_char_p, c_char_p, POINTER(PamConv), POINTER(PamHandle)]

pam_authenticate = libpam.pam_authenticate
pam_authenticate.restype = c_int
pam_authenticate.argtypes = [PamHandle, c_int]

pam_acct_mgmt = libpam.pam_acct_mgmt
pam_acct_mgmt.restype = c_int
pam_acct_mgmt.argtypes = [PamHandle, c_int]


class pam():

    def authenticate_bad(self, username, service='login'):
        handle = PamHandle()
        conv = PamConv(None, 0)
        retval = pam_start(service, username, byref(conv), byref(handle))

        retval = pam_authenticate(handle, 0)
        auth_success = retval == 0

        return auth_success

    def authenticate_good(self, username, service='login'):
        handle = PamHandle()
        conv = PamConv(None, 0)
        retval = pam_start(service, username, byref(conv), byref(handle))

        retval = pam_authenticate(handle, 0)
        if retval == 0:
            retval = pam_acct_mgmt(handle, 0)
        auth_success = retval == 0

        return auth_success
