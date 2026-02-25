import 'dummy';

function t1() {
    function Foo(props) {
        sink(props.field1); // $ hasValueFlow=t1.1
        sink(props.field2); // safe
        return <div>foo</div>;
    }

    function Bar() {
        const taint = source("t1.1");
        return <Foo field1={taint} field2={"safe"} />;
    }
}

function t2() {
    function WithCallback({callback}) {
        callback(source("t2.1"));
        return <div>with callback</div>;
    }
    function Caller() {
        return <WithCallback callback={x => {
            sink(x); // $ hasValueFlow=t2.1
        }} />;
    }
}
