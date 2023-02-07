// Semmle test cases for rule AuthenticationBypass.ql
// Associated with CWE-290: Authentication Bypass by Spoofing
// http://cwe.mitre.org/data/definitions/290.html

///// Library functions //////

extern int strcmp(const char *s1, const char *s2);
extern char *getenv(const char *name);

///// Test cases //////

int isServer;

void processRequest1() 
{
  const char *address = getenv("SERVERIP");

  // BAD: the address is controllable by the user, so it
  // could be spoofed to bypass the security check.
  if (strcmp(address, "127.0.0.1")) {
    isServer = 1;
  }
}

void processRequest2() 
{
  const char *address = getenv("SERVERIP");

  // BAD: the address is controllable by the user, so it
  // could be spoofed to bypass the security check.
  if (strcmp(address, "www.mycompany.com")) {
    isServer = 1;
  }
}

void processRequest3() 
{
  const char *address = getenv("SERVERIP");

  // BAD: the address is controllable by the user, so it
  // could be spoofed to bypass the security check.
  if (strcmp(address, "www.mycompany.co.uk")) {
    isServer = 1;
  }
}

void processRequest4() 
{
  const char *address = getenv("SERVERIP");
  bool cond = false;

  if (strcmp(address, "127.0.0.1")) { cond = true; } // BAD
  if (strcmp(address, "127_0_0_1")) { cond = true; } // GOOD (not an IP)
  if (strcmp(address, "127.0.0")) { cond = true; } // GOOD (not an IP)
  if (strcmp(address, "127.0.0.0.1")) { cond = true; } // GOOD (not an IP)
  if (strcmp(address, "http://mycompany")) { cond = true; } // BAD
  if (strcmp(address, "http_//mycompany")) { cond = true; } // GOOD (not an address)
  if (strcmp(address, "htt://mycompany")) { cond = true; } // GOOD (not an address)
  if (strcmp(address, "httpp://mycompany")) { cond = true; } // GOOD (not an address)
  if (strcmp(address, "mycompany.com")) { cond = true; } // BAD
  if (strcmp(address, "mycompany_com")) { cond = true; } // GOOD (not an address)
  if (strcmp(address, "mycompany.c")) { cond = true; } // GOOD (not an address)
  if (strcmp(address, "mycompany.comm")) { cond = true; } // GOOD (not an address)

  if (cond) {
    isServer = 1;
  }
}

