fn source(i: i64) -> i64 {
    1000 + i
}

fn sink(s: i64) {
    println!("{}", s);
}

fn closure_flow_out() {
    let f = |cond| if cond { source(92) } else { 0 };
    sink(f(true)); // $ hasValueFlow=92
}

fn closure_flow_in() {
    let f = |cond, data| {
        if cond {
            sink(data); // $ hasValueFlow=87
        } else {
            sink(0)
        }
    };
    let a = source(87);
    f(true, a);
}

fn closure_flow_through() {
    let f = |cond, data| if cond { data } else { 0 };
    let a = source(43);
    let b = f(true, a);
    sink(b); // $ hasValueFlow=43
}

fn closure_captured_variable() {
    let mut capt = 1;
    sink(capt);
    let mut f = || {
        capt = source(73);
    };
    f();
    sink(capt); // $ hasValueFlow=73
    let g = || {
        sink(capt); // $ hasValueFlow=73
    };
    g();
}

fn get_from_source() -> i64 {
    source(93)
}

fn pass_to_sink(data: i64) {
    sink(data); // $ hasValueFlow=34
}

fn function_flow_out() {
    let f = get_from_source;
    sink(f()); // $ hasValueFlow=93
}

fn function_flow_in() {
    let f = pass_to_sink;
    let a = source(34);
    f(a);
}

fn get_arg(cond: bool, data: i64) -> i64 {
    if cond {
        data
    } else {
        0
    }
}

fn function_flows_through() {
    let f = get_arg;
    let a = source(56);
    let b = f(true, a);
    sink(b); // $ hasValueFlow=56
}

fn main() {
    closure_flow_out();
    closure_flow_in();
    closure_flow_through();
    closure_captured_variable();
    function_flow_in();
    function_flow_out();
    function_flows_through();
}
