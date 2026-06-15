import java.io.*

fun test0() {
    val bw = BufferedWriter(FileWriter("C:\\test.txt"))
    bw.write("test")
}

fun test1() {
    BufferedWriter(FileWriter("C:\\test.txt")).use { bw ->
        bw.write("test")
    }
}

fun test2() {
    val bw = FileOutputStream(File.createTempFile("","")).bufferedWriter()
    bw.write("test")
}

fun test3() {
    FileOutputStream(File.createTempFile("","")).bufferedWriter().use { bw ->
        bw.write("test")
    }
}

fun test4() {
    val bw = OutputStreamWriter(FileOutputStream(File.createTempFile("",""))).buffered()
    bw.write("test")
}

fun test5() {
    OutputStreamWriter(FileOutputStream(File.createTempFile("",""))).buffered().use { bw ->
        bw.write("test")
    }
}

fun test6() {
    val bw = OutputStreamWriter(FileOutputStream(File.createTempFile("","")))
    bw.write("test")
}

fun test7() {
    OutputStreamWriter(FileOutputStream(File.createTempFile("",""))).use { bw ->
        bw.write("test")
    }
}
