// Type mentions required by type inference

use std::future::Future;
fn mention_dyn_future<T>(f: &dyn Future<Output = T>) {}

fn mention_dyn_fn_once<F>(f: &dyn FnOnce() -> F) {}
