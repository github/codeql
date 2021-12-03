var Hello = React.createClass({
  render: function() {
    var obj = {state: {}};
    obj.state.name = "foo";
    return <div>Hello {obj.state.name}</div>;
  }
});
