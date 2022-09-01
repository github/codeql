fun fn(arr: ByteArray, mt: C) {
    arr[1]
    arr[1, 2]
    mt[1, 2]
}

public operator fun ByteArray.get(i: Int, j: Int) = ""


public class C {
    public operator fun get(i: Int, j: Int) = ""
}
