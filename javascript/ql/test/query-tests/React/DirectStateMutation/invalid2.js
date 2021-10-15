var Hello = React.createClass({
  render: function() {
    this.state.person.name= "bar"
    return <div>Hello {this.props.name}</div>;
  }
});
