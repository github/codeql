
#define F(X) X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
#define X1 F("s")
#define X2 F(X1)
#define X3 F(X2)
#define X4 F(X3)

const char *strings[] = {
    X4
};

