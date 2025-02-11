var Hello = React.createClass({
  render: function() {
    this.state.foo = "bar" // $ TODO-SPURIOUS: Alert
    return <div>Hello {this.props.name}</div>;
  }
});
