
char c;
char *cp;

const char cc;
char const cc2;
const char *ccp;
char const *ccp2;
char * const ccp3;
char const * const ccp4;

volatile char vc;
char volatile vc2;
volatile char *vcp;
char volatile *vcp2;
char * volatile vcp3;
char volatile * volatile vcp4;

char * restrict rcp;
char *__restrict__ rcp2;

void *vp;

const void *cvp;
void const *cvp2;
void * const cvp3;
void const * const cvp4;

void *restrict rvp1;
void *__restrict__ rvp2;

const struct s *csp;
struct s const *csp2;
struct s * const csp3;
struct s const * const csp4;

struct s *restrict rsp1;
struct s *__restrict__ rsp2;

char * const volatile restrict cvrcp;
