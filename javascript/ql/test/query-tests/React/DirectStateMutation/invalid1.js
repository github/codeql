var Hello = React.createClass({
  render: function() {
    this.state.foo = "bar"
    return <div>Hello {this.props.name}</div>;
  }
});
