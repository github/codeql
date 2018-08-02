class C extends React.Component {
    state = {
        p: 42
    };
}

React.createClass({
  getInitialState: function() {
    return {
      p: 42
    };
  }
});

//semmle-extractor-options: --experimental
