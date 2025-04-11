
const BUFFER_LIMIT: usize = 10 * 1024;

fn allocate_buffer(user_input: String) -> Result<*mut u8, Error> {
    let size = user_input.parse::<usize>()?;
    if size > BUFFER_LIMIT {
        return Err("Size exceeds limit".into());
    }
    let num_bytes = size * std::mem::size_of::<u64>();

    let layout = std::alloc::Layout::from_size_align(num_bytes, 1).unwrap();
    unsafe {
        let buffer = std::alloc::alloc(layout); // GOOD

        Ok(buffer)
    }
}
