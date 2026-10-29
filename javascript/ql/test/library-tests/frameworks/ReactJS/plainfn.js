function Hello(props) { // $ threatModelSource=view-component-input
  return <div>Hello {props.name}</div>;
} // $ reactComponent

function Hello2(props) { // $ threatModelSource=view-component-input
    return React.createElement("div");
} // $ reactComponent

function Hello3(props) { // $ threatModelSource=view-component-input
    var x = React.createElement("div");
    return x;
} // $ reactComponent

function NotAComponent(props) {
    if (y)
        return React.createElement("div");
    return g();
}

function SpuriousComponent(props) { // $ threatModelSource=view-component-input
    if (y)
        return React.createElement("div");
    return 42;
} // $ reactComponent
