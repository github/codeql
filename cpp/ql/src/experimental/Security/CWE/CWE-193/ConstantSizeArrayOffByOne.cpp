#define MAX_SIZE 1024

struct FixedArray {
  int buf[MAX_SIZE];
};

int main(){
  FixedArray arr;

  for(int i = 0; i <= MAX_SIZE; i++) {
    arr.buf[i] = 0; // BAD
  }

  for(int i = 0; i < MAX_SIZE; i++) {
    arr.buf[i] = 0; // GOOD
  }
}