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
