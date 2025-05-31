// semmle-extractor-options: --gnu_version 40200

void f(int i, int j) {
    int k = i <? j;
    int l = i >? j;
}

