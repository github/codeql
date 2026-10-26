// BAD: A user-provided Intent is used to launch an arbitrary component
Intent forwardIntent = (Intent) getIntent().getParcelableExtra("forward_intent");
startActivity(forwardIntent);

// GOOD: The destination component is checked before launching it
Intent forwardIntent = (Intent) getIntent().getParcelableExtra("forward_intent");
ComponentName destinationComponent = forwardIntent.resolveActivity(getPackageManager());
if (destinationComponent.getPackageName().equals("safe.package") && 
    destinationComponent.getClassName().equals("SafeClass")) {
    startActivity(forwardIntent);
}

// GOOD: The component that sent the Intent is checked before launching the destination component
Intent forwardIntent = (Intent) getIntent().getParcelableExtra("forward_intent");
ComponentName originComponent = getCallingActivity();
if (originComponent.getPackageName().equals("trusted.package") && originComponent.getClassName().equals("TrustedClass")) {
    startActivity(forwardIntent);
}
