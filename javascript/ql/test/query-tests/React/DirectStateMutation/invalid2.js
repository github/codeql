var Hello = React.createClass({
  render: function() {
    this.state.person.name= "bar" // $ Alert
    return <div>Hello {this.props.name}</div>;
  }
});
