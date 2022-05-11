// Semmle test case for rule TaintedCondition.ql (Untrusted input for a condition).
// Associated with CWE-807: Reliance on Untrusted Inputs in a Security Decision
// http://cwe.mitre.org/data/definitions/807.html


///// Library functions //////
extern int strcmp(const char *s1, const char *s2);
extern char *getenv(const char *name);
extern int strlen(const char *s);


//// Test code /////
int adminPrivileges;
extern const char* adminCookie;

const char *currentUser;

void processRequest() 
{
     const char *userName = getenv("USER_NAME");

     // BAD: the condition is controllable by the user, and
     // the body of the if makes a security decision.
     if (!strcmp(userName, "admin")) {
        adminPrivileges = 1;
     }

     // OK, since the comparison is not to a constant
     const char *cookie = getenv("COOKIE");
     if (!strcmp(cookie, adminCookie)) {
        adminPrivileges = 1;
     }

     if (!strcmp(userName, "nobody")) {
        adminPrivileges = 0; // OK, since it's a 0 and not a 1
     }

     // BAD (requires pointer analysis to catch) [NOT DETECTED]
     const char** userp = &currentUser;
     *userp = userName;
     if (!strcmp(currentUser, "admin")) {
       adminPrivileges = 1;     
     }
}

void bugWithBinop() {
     const char *userName = getenv("USER_NAME");
     
     // The following is tainted, but should not cause
     // the whole program to be considered tainted.
     int bytes = strlen(userName) + 1;
}
