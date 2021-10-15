#define Y "y"

static const char* operator"" _Y ( const char* str, decltype(sizeof(0))) { return str + 1; }

static const char* xy = "X"Y;
static const char* xyxy = "X"Y"X"Y;
static const char* x_y = "X"_Y;
static const char* x_yx_y = "X"_Y"X"_Y;
