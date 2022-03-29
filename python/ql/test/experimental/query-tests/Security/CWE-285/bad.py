from ctypes import CDLL, POINTER, Structure, CFUNCTYPE, cast, byref, sizeof
from ctypes import c_void_p, c_size_t, c_char_p, c_char, c_int
from ctypes import memmove
from ctypes.util import find_library

class PamHandle(Structure):
    _fields_ = [ ("handle", c_void_p) ]

    def __init__(self):
        Structure.__init__(self)
        self.handle = 0

class PamMessage(Structure):
    """wrapper class for pam_message structure"""
    _fields_ = [ ("msg_style", c_int), ("msg", c_char_p) ]

    def __repr__(self):
        return "<PamMessage %i '%s'>" % (self.msg_style, self.msg)

class PamResponse(Structure):
    """wrapper class for pam_response structure"""
    _fields_ = [ ("resp", c_char_p), ("resp_retcode", c_int) ]

    def __repr__(self):
        return "<PamResponse %i '%s'>" % (self.resp_retcode, self.resp)

conv_func = CFUNCTYPE(c_int, c_int, POINTER(POINTER(PamMessage)), POINTER(POINTER(PamResponse)), c_void_p)

class PamConv(Structure):
    """wrapper class for pam_conv structure"""
    _fields_ = [ ("conv", conv_func), ("appdata_ptr", c_void_p) ]

# Various constants
PAM_PROMPT_ECHO_OFF       = 1
PAM_PROMPT_ECHO_ON        = 2
PAM_ERROR_MSG             = 3
PAM_TEXT_INFO             = 4
PAM_REINITIALIZE_CRED     = 8

libc                      = CDLL(find_library("c"))
libpam                    = CDLL(find_library("pam"))

calloc                    = libc.calloc
calloc.restype            = c_void_p
calloc.argtypes           = [c_size_t, c_size_t]

# bug #6 (@NIPE-SYSTEMS), some libpam versions don't include this function
if hasattr(libpam, 'pam_end'):
    pam_end                   = libpam.pam_end
    pam_end.restype           = c_int
    pam_end.argtypes          = [PamHandle, c_int]

pam_start                 = libpam.pam_start
pam_start.restype         = c_int
pam_start.argtypes        = [c_char_p, c_char_p, POINTER(PamConv), POINTER(PamHandle)]

pam_setcred               = libpam.pam_setcred
pam_setcred.restype       = c_int
pam_setcred.argtypes      = [PamHandle, c_int]

pam_strerror              = libpam.pam_strerror
pam_strerror.restype      = c_char_p
pam_strerror.argtypes     = [PamHandle, c_int]

pam_authenticate          = libpam.pam_authenticate
pam_authenticate.restype  = c_int
pam_authenticate.argtypes = [PamHandle, c_int]

pam_acct_mgmt          = libpam.pam_acct_mgmt
pam_acct_mgmt.restype  = c_int
pam_acct_mgmt.argtypes = [PamHandle, c_int]

class pam():
    code   = 0
    reason = None

    def __init__(self):
        pass

    def authenticate(self, username, password, service='login', encoding='utf-8', resetcreds=True):
        @conv_func
        def my_conv(n_messages, messages, p_response, app_data):
                 return 0


        cpassword = c_char_p(password)

        handle = PamHandle()
        conv   = PamConv(my_conv, 0)
        retval = pam_start(service, username, byref(conv), byref(handle))

        retval = pam_authenticate(handle, 0)
        auth_success = retval == 0

        return auth_success