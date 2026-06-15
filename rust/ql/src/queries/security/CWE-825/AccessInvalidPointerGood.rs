
unsafe {
    do_something(&*ptr); // GOOD: dereferences `ptr` while it is still valid
}

// ...

{
    std::ptr::drop_in_place(ptr); // executes the destructor of `*ptr`
}
