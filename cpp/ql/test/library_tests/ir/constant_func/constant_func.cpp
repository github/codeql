int ReturnConstant() {
    return 7;
}

int ReturnConstantPhi(bool b) {
    if (b) {
        return 7;
    }
    else {
        return 7;
    }
}

int GetInt();

int ReturnNonConstantPhi(bool b) {
    if (b) {
        return 7;
    }
    else {
        return GetInt();
    }
}

int ReturnConstantPhiLoop(int x) {
    int y = 7;
    while (x > 0) {
        y = 7;
        --x;
    }
    return y;
}

int UnreachableViaGoto() {
  goto skip;
  return 1;
skip:
  return 0;
}

int UnreachableIf(bool b) {
  int x = 5;
  int y = 10;
  if (b) {
    if (x == y) {
      return 1;
    }
    else {
      return 0;
    }
  }
  else {
    if (x < y) {
      return 0;
    }
    else {
      return 1;
    }
  }
}

int DoWhileFalse() {
  int i = 0;
  do {
    i++;
  } while (false);

  return i;
}

