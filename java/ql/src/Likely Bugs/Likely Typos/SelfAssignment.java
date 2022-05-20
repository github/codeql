static public MotionEvent obtainNoHistory(MotionEvent o) {
    MotionEvent ev = obtain(o.mNumPointers, 1);
    ev.mDeviceId = o.mDeviceId;
    o.mFlags = o.mFlags;  // Variable is assigned to itself
    ...
}

static public MotionEvent obtainNoHistory(MotionEvent o) {
    MotionEvent ev = obtain(o.mNumPointers, 1);
    ev.mDeviceId = o.mDeviceId;
    ev.mFlags = o.mFlags;  // Variable is assigned correctly
    ...
}
