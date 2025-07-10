class Hello extends React.Component {
  render() {
    return <div>Hello {this.props.name}</div>;
  }
  static info() {
    return "Nothing to see here.";
  }
}
Hello.displayName = 'Hello';
Hello.defaultProps = {
  name: 'world'
};

class Hello2 extends React.Component {
    constructor() {
        this.state.foo = 42;
        this.state.bar.foo = 42;
        this.state = { baz: 42};
    }
}
