// semmle-extractor-options: --microsoft

typedef unsigned __int32 u_long;
typedef unsigned __int16 u_short;

double ntohd(unsigned __int64);
float ntohf(unsigned __int32);
u_long ntohl(u_long);
unsigned __int64 ntohll(unsigned __int64);
u_short ntohs(u_short);

typedef void *SOCKET;

int recv(SOCKET s, char *buf, int len, int flags);

char UnsafeUser1(u_long l, char *buf) {
  // BAD: unguarded
  return buf[l];
}

void BadTest(u_long l, u_short s, unsigned __int64 ll, char *buf, SOCKET sock) {
  // BAD: unguarded
  recv(sock, buf, ntohl(l), 0);
  
  // BAD: unguarded
  buf[ntohs(s)];
  
  UnsafeUser1(ntohll(ll), buf);
  
  if(s < 100) {
    // BAD: irrelevant guard
    buf[ntohl(l)];
  }
  
  u_long converted = ntohl(l);
  
  if (converted > 100) {
    // BAD: incorrect guard [FALSE NEGATIVE]
    buf[converted];
  }
  
  if(ntohs(s) < 100) {
    // BAD: irrelevant guard
    buf[converted];
  }
}

char UnsafeUser2(u_long l, char *buf) {
  // GOOD: guarded in caller
  return buf[l];
}

char UnsafeUser3(u_long l, char *buf) {
  // GOOD: guarded in caller
  return buf[l];
}

char UnsafeUser3Wrapper(u_long l, char *buf) {
  if(l < 100) {
    return UnsafeUser3(l, buf);
  } else {
    return 0;
  }
}

void GoodTest(u_long l, u_short s, unsigned __int64 ll, char *buf, char *end, SOCKET sock) {
  u_long converted_l = ntohl(l);

  if(converted_l < 100) {
    // GOOD: guarded locally
    recv(sock, buf, converted_l, 0);
  }
  
  u_short converted_s = ntohs(s);
  if(converted_s < 100) {
    // GOOD: guarded locally
    buf[converted_s];
  }
  
  unsigned __int64 converted_ll = ntohll(ll);
  if(converted_ll < 100) {
    UnsafeUser2(converted_ll, buf);
  }
  
  UnsafeUser3Wrapper(converted_ll, buf);

  if (buf + ntohl(l) < end) { // GOOD: only used in comparison
    // empty
  }
}
