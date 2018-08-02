
int x;

#define STMT x = 1;

#define BLOCK { \
                  x = 1; \
              }

#define STUFF_AND_BLOCK x = 1; \
                        { \
                            x = 1; \
                        } \
                        x = 1;

#define STUFF_AND_START_BLOCK x = 1; \
                              { \
                                  x = 1;

#define STUFF_AND_END_BLOCK     x = 1; \
                            } \
                            x = 1;

#define STMT1 STMT
#define STMT2 STMT
#define STMT3 STMT

#define MEGA_MACRO1 STMT1 \
                    STUFF_AND_START_BLOCK \
                        STMT2 \
                    STUFF_AND_END_BLOCK \
                    STMT3

#define STMT4 STMT
#define STMT5 STMT
#define STMT6 STMT

#define MEGA_MACRO2 STMT4 \
                    STUFF_AND_START_BLOCK \
                        STMT5 \
                    } \
                    STMT6


void f1(void) {
    {
        STMT
    }

    {
        x = 1;
        STMT
        x = 1;
    }

    BLOCK

    STUFF_AND_BLOCK

    {
        x = 1;
    STUFF_AND_END_BLOCK

    STUFF_AND_START_BLOCK
        x = 1;
    }

    MEGA_MACRO1

    MEGA_MACRO2
}

#define P2 } P1
#define P1 { P0 }
#define P0 ;

void f2(void) {
  { P2
}

#define P5(x) } x
#define P4 { P3 }
#define P3 ;

void f3(void) {
  { P5(P4)
}

