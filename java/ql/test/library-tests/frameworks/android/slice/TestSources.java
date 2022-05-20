package com.example.app;

import java.io.FileNotFoundException;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.net.Uri;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.RemoteException;
import androidx.slice.Slice;
import androidx.slice.SliceProvider;

public class TestSources extends SliceProvider {

    void sink(Object o) {}

    // "androidx.slice;SliceProvider;true;onBindSlice;;;Parameter[0];contentprovider",
    @Override
    public Slice onBindSlice(Uri sliceUri) {
        sink(sliceUri); // $hasValueFlow
        return null;
    }

    // "androidx.slice;SliceProvider;true;onCreatePermissionRequest;;;Parameter[0];contentprovider",
    @Override
    public PendingIntent onCreatePermissionRequest(Uri sliceUri, String callingPackage) {
        sink(sliceUri); // $hasValueFlow
        sink(callingPackage); // Safe
        return null;
    }

    // "androidx.slice;SliceProvider;true;onMapIntentToUri;;;Parameter[0];contentprovider",
    @Override
    public Uri onMapIntentToUri(Intent intent) {
        sink(intent); // $hasValueFlow
        return null;
    }

    // "androidx.slice;SliceProvider;true;onSlicePinned;;;Parameter[0];contentprovider",
    public void onSlicePinned(Uri sliceUri) {
        sink(sliceUri); // $hasValueFlow
    }

    // "androidx.slice;SliceProvider;true;onSliceUnpinned;;;Parameter[0];contentprovider"
    public void onSliceUnpinned(Uri sliceUri) {
        sink(sliceUri); // $hasValueFlow
    }

    // Methods needed for compilation

    @Override
    public boolean onCreateSliceProvider() {
        return false;
    }

}
