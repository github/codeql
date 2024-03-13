import java.io.*

fun test0() {
    BufferedReader(FileReader("C:\\test.txt")).use { bw ->
        bw.readLine()
    }
}
