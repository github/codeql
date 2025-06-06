
fn allocate_buffer(user_input: String) -> Result<*mut u8, Error> {
    let num_bytes = user_input.parse::<usize>()? * std::mem::size_of::<u64>();

    let layout = std::alloc::Layout::from_size_align(num_bytes, 1).unwrap();
    unsafe {
        let buffer = std::alloc::alloc(layout); // BAD: uncontrolled allocation size

        Ok(buffer)
    }
}
