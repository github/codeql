
unsafe {
    std::ptr::drop_in_place(ptr); // executes the destructor of `*ptr`
}

// ...

unsafe {
    do_something(&*ptr); // BAD: dereferences `ptr`
}
