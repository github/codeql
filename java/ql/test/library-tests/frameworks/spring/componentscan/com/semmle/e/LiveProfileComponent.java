package com.semmle.e;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile({"annotationProfile"})
public class LiveProfileComponent {}
