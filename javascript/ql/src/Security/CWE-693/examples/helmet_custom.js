app.use(
    helmet({
        contentSecurityPolicy: {
            directives: {
                "script-src": ["'self'", "example.com"],
                "style-src": null,
            },
        },
    })
);