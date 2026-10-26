var Hello = React.createClass({
  render: function() {
    this.state.foo = "bar" // $ Alert
    return <div>Hello {this.props.name}</div>;
  }
});
