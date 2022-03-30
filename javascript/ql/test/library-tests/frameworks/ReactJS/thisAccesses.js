class C extends React.Component {
    constructor () {
        this;

        var dis = this;
        dis.p;

        (function () {
            this;
        }).bind(this);
    }

    someInstanceMethod() {
        this;
    }
}

React.createClass({
    render: function() {
        (function () {
            this;
        }).bind(this);
        return <div/>;
    },

    someInstanceMethod: function() {
        this;
    }
});

(function (props) {
    (function () {
        this; props;
    }).bind(this);
    return <div/>;
})

React.createClass({
    render: function() {
        React.Children.map(whatEver, function () {
            this;
        }, this)
        return <div/>;
    },
});

class C2 extends React.Component {
    constructor (y) {
        this.state = x;
        this.state = y;
    }
}

class C3 extends React.Component {
    constructor() {

    }

    render() {
        var foo = <this.name></this.name>;
        var bar = <this.this></this.this>;
    }
}
