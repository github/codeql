def authenticate(self, username, password, service='login', encoding='utf-8', resetcreds=True):
  libpam                    = CDLL(find_library("pam"))
  pam_authenticate          = libpam.pam_authenticate
  pam_acct_mgmt          = libpam.pam_acct_mgmt
  pam_authenticate.restype  = c_int
  pam_authenticate.argtypes = [PamHandle, c_int]
  pam_acct_mgmt.restype  = c_int
  pam_acct_mgmt.argtypes = [PamHandle, c_int]
  
  handle = PamHandle()
  conv   = PamConv(my_conv, 0)
  retval = pam_start(service, username, byref(conv), byref(handle))

  retval = pam_authenticate(handle, 0)
  if retval == 0:
      retval = pam_acct_mgmt(handle, 0)
  return retval == 0