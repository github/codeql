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
  if (b) {
    if (false) {
      return 1;
    }
    else {
      return 0;
    }
  }
  else {
    if (true) {
      return 0;
    }
    else {
      return 1;
    }
  }
}
