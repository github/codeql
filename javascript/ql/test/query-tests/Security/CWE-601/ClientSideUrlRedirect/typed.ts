export class MyComponent {
    componentDidMount() {
        const { location }: { location: Location } = (this as any).props;
        var params = location.search;
        this.doRedirect(params);
    }
    private doRedirect(redirectUri: string) {
        window.location.replace(redirectUri);
    }
}

export class MyTrackingComponent {
    componentDidMount() {
        const { location }: { location: Location } = (this as any).props; // location source

        var container = {
            loc: location
        };
        var secondLoc = container.loc; // type-tracking step 1 - not the source
        
        this.myIndirectRedirect(secondLoc); 
    }

    private myIndirectRedirect(loc) { // type-tracking step 2 - also not the source
        this.doRedirect(loc.search);
    }

    private doRedirect(redirectUri: string) {
        window.location.replace(redirectUri);
    }
}