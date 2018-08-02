function Hello(props) {
  return <div>Hello {props.name}</div>;
}

function Hello2(props) {
    return React.createElement("div");
}

function Hello3(props) {
    var x = React.createElement("div");
    return x;
}

function NotAComponent(props) {
    if (y)
        return React.createElement("div");
    return g();
}

function SpuriousComponent(props) {
    if (y)
        return React.createElement("div");
    return 42;
}
