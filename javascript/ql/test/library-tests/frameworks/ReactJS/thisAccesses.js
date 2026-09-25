class C extends React.Component { // $ reactComponent
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

React.createClass({ // $ reactComponent
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

(function (props) { // $ threatModelSource=view-component-input reactComponent
    (function () {
        this; props;
    }).bind(this);
    return <div/>;
})

React.createClass({ // $ reactComponent
    render: function() {
        React.Children.map(whatEver, function () {
            this;
        }, this)
        return <div/>;
    },
});

class C2 extends React.Component { // $ reactComponent
    constructor (y) { // $ threatModelSource=view-component-input
        this.state = x;
        this.state = y;
    }
}

class C3 extends React.Component { // $ reactComponent
    constructor() {

    }

    render() {
        var foo = <this.name></this.name>;
        var bar = <this.this></this.this>;
    }
}
