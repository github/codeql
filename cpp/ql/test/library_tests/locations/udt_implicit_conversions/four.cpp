struct Four {
  operator int() {
    return 4;
  }
};

int main() {
  Four four;
  return four; // There is a call to operator int() here. [ITS LOCATION SHOULD BE THE ENTIRE WORD 'four']
}
