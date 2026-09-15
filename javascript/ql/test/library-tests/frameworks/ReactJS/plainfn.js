function Hello(props) { // $ threatModelSource=view-component-input reactComponent
  return <div>Hello {props.name}</div>;
}

function Hello2(props) { // $ threatModelSource=view-component-input reactComponent
    return React.createElement("div");
}

function Hello3(props) { // $ threatModelSource=view-component-input reactComponent
    var x = React.createElement("div");
    return x;
}

function NotAComponent(props) {
    if (y)
        return React.createElement("div");
    return g();
}

function SpuriousComponent(props) { // $ threatModelSource=view-component-input reactComponent
    if (y)
        return React.createElement("div");
    return 42;
}
