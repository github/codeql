fun fn(arr: ByteArray, mt: C) {
    arr[1]
    arr[1, 2]
    mt[1, 2]

    arr[1, 2] = 3
    arr[1] = C()
}

public operator fun ByteArray.get(i: Int, j: Int) = ""
public operator fun ByteArray.set(i: Int, j: Int, k: Int) = ""
public operator fun ByteArray.set(i: Int, c: C) = ""


public class C {
    public operator fun get(i: Int, j: Int) = ""
}
