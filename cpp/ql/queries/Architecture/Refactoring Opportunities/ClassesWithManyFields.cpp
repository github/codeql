//This struct contains 30 fields.
struct MyParticle {
  bool isActive;
  int priority;

  float x, y, z;
  float dx, dy, dz;
  float ddx, ddy, ddz;
  bool isCollider;

  int age, maxAge;
  float size1, size2;

  bool hasColor;
  unsigned char r1, g1, b1, a1;
  unsigned char r2, g2, b2, a2;

  class texture *tex;
  float u1, v1, u2, v2;
};
