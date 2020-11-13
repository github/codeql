/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package android.content;

import android.content.pm.PackageManager;
import android.os.Bundle;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.concurrent.Executor;

public abstract class Context {
    public static final int MODE_PRIVATE = 0x0000;
    public static final int MODE_WORLD_READABLE = 0x0001;
    public static final int MODE_WORLD_WRITEABLE = 0x0002;

    public static final int MODE_APPEND = 0x8000;
    public static final int MODE_MULTI_PROCESS = 0x0004;
    public static final int MODE_ENABLE_WRITE_AHEAD_LOGGING = 0x0008;
    public static final int MODE_NO_LOCALIZED_COLLATORS = 0x0010;

    public @interface BindServiceFlags {
    }

    public static final int BIND_AUTO_CREATE = 0x0001;

    public static final int BIND_DEBUG_UNBIND = 0x0002;

    public static final int BIND_NOT_FOREGROUND = 0x0004;

    public static final int BIND_ABOVE_CLIENT = 0x0008;

    public static final int BIND_ALLOW_OOM_MANAGEMENT = 0x0010;

    public static final int BIND_WAIVE_PRIORITY = 0x0020;

    public static final int BIND_IMPORTANT = 0x0040;

    public static final int BIND_ADJUST_WITH_ACTIVITY = 0x0080;

    public static final int BIND_NOT_PERCEPTIBLE = 0x00000100;

    public static final int BIND_INCLUDE_CAPABILITIES = 0x000001000;

    public static final int BIND_SCHEDULE_LIKE_TOP_APP = 0x00080000;

    public static final int BIND_ALLOW_BACKGROUND_ACTIVITY_STARTS = 0x00100000;

    public static final int BIND_RESTRICT_ASSOCIATIONS = 0x00200000;

    public static final int BIND_ALLOW_INSTANT = 0x00400000;

    public static final int BIND_IMPORTANT_BACKGROUND = 0x00800000;

    public static final int BIND_ALLOW_WHITELIST_MANAGEMENT = 0x01000000;

    public static final int BIND_FOREGROUND_SERVICE_WHILE_AWAKE = 0x02000000;

    public static final int BIND_FOREGROUND_SERVICE = 0x04000000;

    public static final int BIND_TREAT_LIKE_ACTIVITY = 0x08000000;

    public static final int BIND_VISIBLE = 0x10000000;

    public static final int BIND_SHOWING_UI = 0x20000000;

    public static final int BIND_NOT_VISIBLE = 0x40000000;
    public static final int BIND_EXTERNAL_SERVICE = 0x80000000;
    public static final int BIND_REDUCTION_FLAGS = Context.BIND_ALLOW_OOM_MANAGEMENT | Context.BIND_WAIVE_PRIORITY
            | Context.BIND_NOT_PERCEPTIBLE | Context.BIND_NOT_VISIBLE;

    public @interface RegisterReceiverFlags {
    }

    public static final int RECEIVER_VISIBLE_TO_INSTANT_APPS = 0x1;

    public abstract PackageManager getPackageManager();

    public abstract Context getApplicationContext();

    public abstract ClassLoader getClassLoader();

    public String getOpPackageName() {
        throw new RuntimeException("Not implemented. Must override in a subclass.");
    }

    public String getAttributionTag() {
        return null;
    }

    public String getFeatureId() {
        return getAttributionTag();
    }

    public boolean canStartActivityForResult() {
        return false;
    }

    public abstract void startActivity(Intent intent);

    public abstract void sendBroadcast(Intent intent);

    public abstract void sendBroadcast(Intent intent, String receiverPermission);

    public void sendBroadcastMultiplePermissions(Intent intent, String[] receiverPermissions) {
        throw new RuntimeException("Not implemented. Must override in a subclass.");
    }

    public void sendBroadcastWithMultiplePermissions(Intent intent, String[] receiverPermissions) {
        sendBroadcastMultiplePermissions(intent, receiverPermissions);
    }

    public abstract void sendBroadcast(Intent intent, String receiverPermission, Bundle options);

    public abstract void sendBroadcast(Intent intent, String receiverPermission, int appOp);

    public abstract void sendOrderedBroadcast(Intent intent, String receiverPermission);

    public @interface ServiceName {
    }

    public static final String POWER_SERVICE = "power";

    public static final String RECOVERY_SERVICE = "recovery";

    public static final String SYSTEM_UPDATE_SERVICE = "system_update";

    public static final String WINDOW_SERVICE = "window";

    public static final String LAYOUT_INFLATER_SERVICE = "layout_inflater";

    public static final String ACCOUNT_SERVICE = "account";

    public static final String ACTIVITY_SERVICE = "activity";

    public static final String ACTIVITY_TASK_SERVICE = "activity_task";

    public static final String URI_GRANTS_SERVICE = "uri_grants";

    public static final String ALARM_SERVICE = "alarm";

    public static final String NOTIFICATION_SERVICE = "notification";

    public static final String ACCESSIBILITY_SERVICE = "accessibility";

    public static final String CAPTIONING_SERVICE = "captioning";

    public static final String KEYGUARD_SERVICE = "keyguard";

    public static final String LOCATION_SERVICE = "location";

    public static final String COUNTRY_DETECTOR = "country_detector";

    public static final String SEARCH_SERVICE = "search";

    public static final String SENSOR_SERVICE = "sensor";

    public static final String SENSOR_PRIVACY_SERVICE = "sensor_privacy";

    public static final String STORAGE_SERVICE = "storage";

    public static final String STORAGE_STATS_SERVICE = "storagestats";

    public static final String WALLPAPER_SERVICE = "wallpaper";

    public static final String VIBRATOR_SERVICE = "vibrator";

    public static final String STATUS_BAR_SERVICE = "statusbar";

    public static final String CONNECTIVITY_SERVICE = "connectivity";

    public static final String VCN_MANAGEMENT_SERVICE = "vcn_management";

    public static final String NETD_SERVICE = "netd";

    public static final String NETWORK_STACK_SERVICE = "network_stack";

    public static final String TETHERING_SERVICE = "tethering";

    public static final String IPSEC_SERVICE = "ipsec";

    public static final String VPN_MANAGEMENT_SERVICE = "vpn_management";

    public static final String CONNECTIVITY_DIAGNOSTICS_SERVICE = "connectivity_diagnostics";

    public static final String TEST_NETWORK_SERVICE = "test_network";

    public static final String UPDATE_LOCK_SERVICE = "updatelock";

    public static final String NETWORKMANAGEMENT_SERVICE = "network_management";

    public static final String SLICE_SERVICE = "slice";

    public static final String NETWORK_STATS_SERVICE = "netstats";

    public static final String NETWORK_POLICY_SERVICE = "netpolicy";

    public static final String NETWORK_WATCHLIST_SERVICE = "network_watchlist";

    public static final String WIFI_SERVICE = "wifi";

    public static final String WIFI_NL80211_SERVICE = "wifinl80211";

    public static final String WIFI_P2P_SERVICE = "wifip2p";

    public static final String WIFI_AWARE_SERVICE = "wifiaware";

    public static final String WIFI_SCANNING_SERVICE = "wifiscanner";

    public static final String WIFI_RTT_SERVICE = "rttmanager";

    public static final String WIFI_RTT_RANGING_SERVICE = "wifirtt";

    public static final String LOWPAN_SERVICE = "lowpan";

    public static final String ETHERNET_SERVICE = "ethernet";

    public static final String NSD_SERVICE = "servicediscovery";

    public static final String AUDIO_SERVICE = "audio";

    public static final String AUTH_SERVICE = "auth";

    public static final String FINGERPRINT_SERVICE = "fingerprint";

    public static final String FACE_SERVICE = "face";

    public static final String IRIS_SERVICE = "iris";

    public static final String BIOMETRIC_SERVICE = "biometric";

    public static final String MEDIA_ROUTER_SERVICE = "media_router";

    public static final String MEDIA_SESSION_SERVICE = "media_session";

    public static final String TELEPHONY_SERVICE = "phone";

    public static final String TELEPHONY_SUBSCRIPTION_SERVICE = "telephony_subscription_service";

    public static final String TELECOM_SERVICE = "telecom";

    public static final String CARRIER_CONFIG_SERVICE = "carrier_config";

    public static final String EUICC_SERVICE = "euicc";

    public static final String EUICC_CARD_SERVICE = "euicc_card";

    public static final String MMS_SERVICE = "mms";

    public static final String CLIPBOARD_SERVICE = "clipboard";

    public static final String TEXT_CLASSIFICATION_SERVICE = "textclassification";

    public static final String ATTENTION_SERVICE = "attention";

    public static final String INPUT_METHOD_SERVICE = "input_method";

    public static final String TEXT_SERVICES_MANAGER_SERVICE = "textservices";

    public static final String APPWIDGET_SERVICE = "appwidget";

    public static final String VOICE_INTERACTION_MANAGER_SERVICE = "voiceinteraction";

    public static final String AUTOFILL_MANAGER_SERVICE = "autofill";

    public static final String CONTENT_CAPTURE_MANAGER_SERVICE = "content_capture";

    public static final String CONTENT_SUGGESTIONS_SERVICE = "content_suggestions";

    public static final String APP_PREDICTION_SERVICE = "app_prediction";

    public static final String SOUND_TRIGGER_SERVICE = "soundtrigger";

    public static final String SOUND_TRIGGER_MIDDLEWARE_SERVICE = "soundtrigger_middleware";

    public static final String PERMISSION_SERVICE = "permission";

    public static final String PERMISSION_CONTROLLER_SERVICE = "permission_controller";

    public static final String BACKUP_SERVICE = "backup";

    public static final String ROLLBACK_SERVICE = "rollback";

    public static final String DROPBOX_SERVICE = "dropbox";

    public static final String DEVICE_IDLE_CONTROLLER = "deviceidle";

    public static final String POWER_WHITELIST_MANAGER = "power_whitelist";

    public static final String DEVICE_POLICY_SERVICE = "device_policy";

    public static final String UI_MODE_SERVICE = "uimode";

    public static final String DOWNLOAD_SERVICE = "download";

    public static final String BATTERY_SERVICE = "batterymanager";

    public static final String NFC_SERVICE = "nfc";

    public static final String BLUETOOTH_SERVICE = "bluetooth";

    public static final String SIP_SERVICE = "sip";

    public static final String USB_SERVICE = "usb";

    public static final String ADB_SERVICE = "adb";

    public static final String SERIAL_SERVICE = "serial";

    public static final String HDMI_CONTROL_SERVICE = "hdmi_control";

    public static final String INPUT_SERVICE = "input";

    public static final String DISPLAY_SERVICE = "display";

    public static final String COLOR_DISPLAY_SERVICE = "color_display";

    public static final String USER_SERVICE = "user";

    public static final String LAUNCHER_APPS_SERVICE = "launcherapps";

    public static final String RESTRICTIONS_SERVICE = "restrictions";

    public static final String APP_OPS_SERVICE = "appops";

    public static final String ROLE_SERVICE = "role";

    public static final String ROLE_CONTROLLER_SERVICE = "role_controller";

    public static final String CAMERA_SERVICE = "camera";

    public static final String PRINT_SERVICE = "print";

    public static final String COMPANION_DEVICE_SERVICE = "companiondevice";

    public static final String CONSUMER_IR_SERVICE = "consumer_ir";

    public static final String TRUST_SERVICE = "trust";

    public static final String TV_INPUT_SERVICE = "tv_input";

    public static final String TV_TUNER_RESOURCE_MGR_SERVICE = "tv_tuner_resource_mgr";

    public static final String NETWORK_SCORE_SERVICE = "network_score";

    public static final String USAGE_STATS_SERVICE = "usagestats";

    public static final String JOB_SCHEDULER_SERVICE = "jobscheduler";

    public static final String PERSISTENT_DATA_BLOCK_SERVICE = "persistent_data_block";

    public static final String OEM_LOCK_SERVICE = "oem_lock";

    public static final String MEDIA_PROJECTION_SERVICE = "media_projection";

    public static final String MIDI_SERVICE = "midi";

    public static final String RADIO_SERVICE = "broadcastradio";

    public static final String HARDWARE_PROPERTIES_SERVICE = "hardware_properties";

    public static final String THERMAL_SERVICE = "thermalservice";

    public static final String SHORTCUT_SERVICE = "shortcut";

    public static final String CONTEXTHUB_SERVICE = "contexthub";

    public static final String SYSTEM_HEALTH_SERVICE = "systemhealth";

    public static final String GATEKEEPER_SERVICE = "android.service.gatekeeper.IGateKeeperService";

    public static final String DEVICE_IDENTIFIERS_SERVICE = "device_identifiers";

    public static final String INCIDENT_SERVICE = "incident";

    public static final String INCIDENT_COMPANION_SERVICE = "incidentcompanion";

    public static final String STATS_MANAGER_SERVICE = "statsmanager";

    public static final String STATS_COMPANION_SERVICE = "statscompanion";

    public static final String STATS_MANAGER = "stats";

    public static final String PLATFORM_COMPAT_SERVICE = "platform_compat";

    public static final String PLATFORM_COMPAT_NATIVE_SERVICE = "platform_compat_native";

    public static final String BUGREPORT_SERVICE = "bugreport";

    public static final String OVERLAY_SERVICE = "overlay";

    public static final String IDMAP_SERVICE = "idmap";

    public static final String VR_SERVICE = "vrmanager";

    public static final String TIME_ZONE_RULES_MANAGER_SERVICE = "timezone";

    public static final String CROSS_PROFILE_APPS_SERVICE = "crossprofileapps";

    public static final String SECURE_ELEMENT_SERVICE = "secure_element";

    public static final String TIME_DETECTOR_SERVICE = "time_detector";

    public static final String TIME_ZONE_DETECTOR_SERVICE = "time_zone_detector";

    public static final String APP_BINDING_SERVICE = "app_binding";

    public static final String TELEPHONY_IMS_SERVICE = "telephony_ims";

    public static final String SYSTEM_CONFIG_SERVICE = "system_config";

    public static final String TELEPHONY_RCS_MESSAGE_SERVICE = "ircsmessage";

    public static final String DYNAMIC_SYSTEM_SERVICE = "dynamic_system";

    public static final String BLOB_STORE_SERVICE = "blob_store";

    public static final String TELEPHONY_REGISTRY_SERVICE = "telephony_registry";

    public static final String BATTERY_STATS_SERVICE = "batterystats";

    public static final String APP_INTEGRITY_SERVICE = "app_integrity";

    public static final String DATA_LOADER_MANAGER_SERVICE = "dataloader_manager";

    public static final String INCREMENTAL_SERVICE = "incremental";

    public static final String FILE_INTEGRITY_SERVICE = "file_integrity";

    public static final String LIGHTS_SERVICE = "lights";

    public static final String UWB_SERVICE = "uwb";

    public static final String DREAM_SERVICE = "dream";

    public @interface CreatePackageOptions {
    }

    public static final int CONTEXT_INCLUDE_CODE = 0x00000001;

    public static final int CONTEXT_IGNORE_SECURITY = 0x00000002;

    public static final int CONTEXT_RESTRICTED = 0x00000004;

    public static final int CONTEXT_DEVICE_PROTECTED_STORAGE = 0x00000008;

    public static final int CONTEXT_CREDENTIAL_PROTECTED_STORAGE = 0x00000010;

    public static final int CONTEXT_REGISTER_PACKAGE = 0x40000000;

    public abstract Context createPackageContext(String packageName, int flags) throws Exception;

    public Context createWindowContext(int type, Bundle options) {
        throw new RuntimeException("Not implemented. Must override in a subclass.");
    }

    public Context createAttributionContext(String attributionTag) {
        throw new RuntimeException("Not implemented. Must override in a subclass.");
    }

    public Context createFeatureContext(String featureId) {
        return createAttributionContext(featureId);
    }

    public abstract SharedPreferences getSharedPreferences(String name, int mode);

    public boolean isRestricted() {
        return false;
    }

    public boolean isUiContext() {
        throw new RuntimeException("Not implemented. Must override in a subclass.");
    }

}
