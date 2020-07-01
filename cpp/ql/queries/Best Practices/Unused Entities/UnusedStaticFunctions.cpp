//start of file
static void f() { //static function f() is unused in the file
    //...
}
static void g() {
    //...
}
void public_func() { //non-static function public_func is not called in file, 
                     //but could be visible in other files
    //...
    g(); //call to g()
    //...
}
//end of file
