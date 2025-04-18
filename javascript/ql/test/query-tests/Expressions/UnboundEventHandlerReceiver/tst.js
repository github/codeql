import React from 'react';
import autoBind from 'auto-bind';
import reactAutobind from 'react-autobind';
class Component0 extends React.Component {

    render() {
        return <div>
            <div onClick={this.bound_throughAutoBind}/>
            </div>
    }

    constructor(props) {
        super(props);
        autoBind(this);
    }

    bound_throughAutoBind() {
        this.setState({ });
    }
}

class Component1 extends React.Component {

    render() {
        var unbound3 = this.unbound3;
        return <div>
            <div onClick={this.unbound1}/> { /* $ Alert */ }
            <div onClick={this.unbound2}/> { /* $ Alert */ }
            <div onClick={unbound3}/> { /* $ Alert */ }
            <div onClick={this.bound_throughBindInConstructor}/>
            <div onClick={this.bound_throughDeclaration}/>
            <div onClick={this.unbound_butNoThis}/>
            <div onClick={this.unbound_butNoThis2}/>
            <div onClick={(e) => this.unbound_butInvokedSafely(e)}/>
            <div onClick={this.bound_throughBindInMethod}/>
            <div onClick={this.bound_throughNonSyntacticBindInConstructor}/>
            <div onClick={this.bound_throughBindAllInConstructor1}/>
            <div onClick={this.bound_throughBindAllInConstructor2}/>
            <div onClick={this.bound_throughDecorator_autobind}/>
            <div onClick={this.bound_throughDecorator_actionBound}/>
            </div>
    }

    constructor(props) {
        super(props);
        this.bound_throughBindInConstructor = this.bound_throughBindInConstructor.bind(this);
        this.bound_throughBizarreBind = foo.bar.bind(baz);
        var cmp = this;
        var bound = (cmp.bound_throughNonSyntacticBindInConstructor.bind(this));
        (cmp).bound_throughNonSyntacticBindInConstructor = bound;
        _.bindAll(this, 'bound_throughBindAllInConstructor1');
        _.bindAll(this, ['bound_throughBindAllInConstructor2']);
    }

    unbound1() {
        this.setState({ });
    }

    unbound2() {
        () => this.setState({ });
    }

    unbound3() {
        () => this.setState({ });
    }

    bound_throughBindInConstructor() {
        this.setState({ });
    }

    bound_throughNonSyntacticBindInConstructor() {
        this.setState({ });
    }

    bound_throughBizzareBind() {
        this.setState({ });
    }

    bound_throughDeclaration = () => {
        this.setState({ });
    }

    unbound_butNoThis1() {

    }

    unbound_butNoThis2() {
        (function(){ this.setState({ })});
    }

    unbound_butInvokedSafely() {
        this.setState({ });
    }

    componentWillMount() {
        this.bound_throughBindInMethod = this.bound_throughBindInMethod.bind(this);
    }

    bound_throughBindInMethod() {
        this.setState({ });
    }

    bound_throughBindAllInConstructor1() {
        this.setState({ });
    }

    bound_throughBindAllInConstructor2() {
        this.setState({ });
    }

    @autobind
    bound_throughDecorator_autobind() {
        this.setState({ });
    }

    @action.bound
    bound_throughDecorator_actionBound() {
        this.setState({ });
    }

}

@autobind
class Component2 extends React.Component {

    render() {
        return <div>
            <div onClick={this.bound_throughClassDecorator_autobind}/>
            </div>;
    }

    bound_throughClassDecorator_autobind() {
        this.setState({ });
    }

}

class Component3 extends React.Component {

    render() {
        return <div>
            <div onClick={this.bound_throughIterator}/>
            </div>
    }

    constructor(props) {
        super(props);
	    Object.getOwnPropertyNames( Component3.prototype )
		    .filter( prop => typeof this[ prop ] === 'function' )
		    .forEach( prop => ( this[ prop ] = this[ prop ].bind( this ) ) );
    }

    bound_throughIterator() {
        this.setState({ });
    }
}

class Component4 extends React.Component {

    render() {
        return <div>
            <div onClick={this.bound_throughReactAutobind}/>
            </div>
    }

    constructor(props) {
        super(props);
        reactAutobind(this);
    }

    bound_throughReactAutobind() {
        this.setState({ });
    }
}

class Component5 extends React.Component {

    render() {
        return <div>
            <div onClick={this.bound_throughSomeBinder}/>
            </div>
    }

    constructor(props) {
        super(props);
	    someBind(this, "bound_throughSomeBinder");
    }

    bound_throughSomeBinder() {
        this.setState({ });
    }
}
