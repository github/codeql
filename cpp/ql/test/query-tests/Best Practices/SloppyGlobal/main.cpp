// main.cpp

int x; // BAD: too short
int ys[1000000]; // BAD: too short
int descriptive_name; // GOOD: sufficient

static int z; // GOOD: not a global

int v1; // BAD: too short
int v2; // BAD: too short
template <typename T>
T v3; // BAD: too short
template <typename T>
T v4; // BAD: too short
template <typename T>
T v5; // BAD: too short

void use_some_fs() {
    v2 = 100;
    v4<int> = 200;
    v5<int> = 300;
    v5<const char *> = "string";
}
