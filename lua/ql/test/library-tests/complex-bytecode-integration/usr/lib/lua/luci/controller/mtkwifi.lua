-- This module is a demo to configure MTK' proprietary WiFi driver.
-- Basic idea is to bypass uci and edit wireless profile (mt76xx.dat) directly.
-- LuCI's WiFi configuration is more logical and elegent, but it's quite tricky to 
-- translate uci into MTK's WiFi profile (like we did in "uci2dat").
-- And you will get your hands dirty.
-- 
-- Hua Shao <nossiac@163.com>

package.path = '/lib/wifi/?.lua;'..package.path
module("luci.controller.mtkwifi", package.seeall)
local onboardingType = 0;
local ioctl_help = require "ioctl_helper"
local map_help
if pcall(require, "map_helper") then
    map_help = require "map_helper"
end
local http = require("luci.http")
local mtkwifi = require("mtkwifi")

local logDisable = 1
function debug_write(...)
    -- luci.http.write(...)
    if logDisable == 1 then
        return
    end
    local syslog_msg = "";
    local ff = io.open("/tmp/dbgmsg", "a")
    local nargs = select('#',...)

    for n=1, nargs do
      local v = select(n,...)
      if (type(v) == "string" or type(v) == "number") then
        ff:write(v.." ")
        syslog_msg = syslog_msg..v.." ";
      elseif (type(v) == "boolean") then
        if v then
          ff:write("true ")
          syslog_msg = syslog_msg.."true ";
        else
          ff:write("false ")
          syslog_msg = syslog_msg.."false ";
        end
      elseif (type(v) == "nil") then
        ff:write("nil ")
        syslog_msg = syslog_msg.."nil ";
      else
        ff:write("<Non-printable data type = "..type(v).."> ")
        syslog_msg = syslog_msg.."<Non-printable data type = "..type(v).."> ";
      end
    end
    ff:write("\n")
    ff:close()
    nixio.syslog("debug", syslog_msg)
end

function index()
    -- if not nixio.fs.access("/etc/wireless") then
    --     return
    -- end

    entry({"admin", "mtk"}, firstchild(), _("MTK"), 80)
    entry({"admin", "mtk", "test"}, call("test"))
    entry({"admin", "mtk", "wifi"}, template("admin_mtk/mtk_wifi_overview"), _("WiFi configuration"), 1)
    entry({"admin", "mtk", "wifi", "chip_cfg_view"}, template("admin_mtk/mtk_wifi_chip_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "chip_cfg"}, call("chip_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "dev_cfg_view"}, template("admin_mtk/mtk_wifi_dev_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "dev_cfg"}, call("dev_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "dev_cfg_raw"}, call("dev_cfg_raw")).leaf = true
    entry({"admin", "mtk", "wifi", "vif_cfg_view"}, template("admin_mtk/mtk_wifi_vif_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "vif_cfg"}, call("vif_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "vif_add_view"}, template("admin_mtk/mtk_wifi_vif_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "vif_add"}, call("vif_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "vif_del"}, call("vif_del")).leaf = true
    entry({"admin", "mtk", "wifi", "vif_disable"}, call("vif_disable")).leaf = true
    entry({"admin", "mtk", "wifi", "vif_enable"}, call("vif_enable")).leaf = true
    entry({"admin", "mtk", "wifi", "get_station_list"}, call("get_station_list"))
    entry({"admin", "mtk", "wifi", "get_country_region_list"}, call("get_country_region_list")).leaf = true
    entry({"admin", "mtk", "wifi", "get_channel_list"}, call("get_channel_list"))
    entry({"admin", "mtk", "wifi", "get_HT_ext_channel_list"}, call("get_HT_ext_channel_list"))
    entry({"admin", "mtk", "wifi", "get_5G_2nd_80Mhz_channel_list"}, call("get_5G_2nd_80Mhz_channel_list"))
    entry({"admin", "mtk", "wifi", "reset"}, call("reset_wifi")).leaf = true
    entry({"admin", "mtk", "wifi", "reload"}, call("reload_wifi")).leaf = true
    entry({"admin", "mtk", "wifi", "get_raw_profile"}, call("get_raw_profile"))
    entry({"admin", "mtk", "wifi", "apcli_cfg_view"}, template("admin_mtk/mtk_wifi_apcli")).leaf = true
    entry({"admin", "mtk", "wifi", "apcli_cfg"}, call("apcli_cfg")).leaf = true
    entry({"admin", "mtk", "wifi", "apcli_disconnect"}, call("apcli_disconnect")).leaf = true
    entry({"admin", "mtk", "wifi", "apcli_connect"}, call("apcli_connect")).leaf = true
    entry({"admin", "mtk", "netmode", "net_cfg"}, call("net_cfg"))
    entry({"admin", "mtk", "console"}, template("admin_mtk/mtk_web_console"), _("Web Console"), 4)
    entry({"admin", "mtk", "webcmd"}, call("webcmd"))
    -- entry({"admin", "mtk", "man"}, template("admin_mtk/mtk_wifi_man"), _("M.A.N"), 3)
    -- entry({"admin", "mtk", "man", "cfg"}, call("man_cfg"))
    entry({"admin", "mtk", "wifi", "get_wps_info"}, call("get_WPS_Info")).leaf = true
    entry({"admin", "mtk", "wifi", "get_wifi_pin"}, call("get_wifi_pin")).leaf = true
    entry({"admin", "mtk", "wifi", "set_wifi_gen_pin"}, call("set_wifi_gen_pin")).leaf = true
    entry({"admin", "mtk", "wifi", "set_wifi_wps_oob"}, call("set_wifi_wps_oob")).leaf = true
    entry({"admin", "mtk", "wifi", "set_wifi_do_wps"}, call("set_wifi_do_wps")).leaf = true
    entry({"admin", "mtk", "wifi", "get_wps_security"}, call("get_wps_security")).leaf = true
    entry({"admin", "mtk", "wifi", "apcli_get_wps_status"}, call("apcli_get_wps_status")).leaf = true;
    entry({"admin", "mtk", "wifi", "apcli_do_enr_pin_wps"}, call("apcli_do_enr_pin_wps")).leaf = true;
    entry({"admin", "mtk", "wifi", "apcli_do_enr_pbc_wps"}, call("apcli_do_enr_pbc_wps")).leaf = true;
    entry({"admin", "mtk", "wifi", "apcli_cancel_wps"}, call("apcli_cancel_wps")).leaf = true;
    entry({"admin", "mtk", "wifi", "apcli_wps_gen_pincode"}, call("apcli_wps_gen_pincode")).leaf = true;
    entry({"admin", "mtk", "wifi", "apcli_wps_get_pincode"}, call("apcli_wps_get_pincode")).leaf = true;
    entry({"admin", "mtk", "wifi", "apcli_scan"}, call("apcli_scan")).leaf = true;
    entry({"admin", "mtk", "wifi", "sta_info"}, call("sta_info")).leaf = true;
    entry({"admin", "mtk", "wifi", "get_apcli_conn_info"}, call("get_apcli_conn_info")).leaf = true;
    entry({"admin", "mtk", "wifi", "apply_power_boost_settings"}, call("apply_power_boost_settings")).leaf = true;
    entry({"admin", "mtk", "wifi", "apply_reboot"}, template("admin_mtk/mtk_wifi_apply_reboot")).leaf = true;
    entry({"admin", "mtk", "wifi", "reboot"}, call("exec_reboot")).leaf = true;
    entry({"admin", "mtk", "wifi", "get_bssid_num"}, call("get_bssid_num")).leaf = true;
    entry({"admin", "mtk", "wifi", "loading"}, template("admin_mtk/mtk_wifi_loading")).leaf = true;
    entry({"admin", "mtk", "wifi", "get_apply_status"}, call("get_apply_status")).leaf = true;
    entry({"admin", "mtk", "wifi", "reset_to_defaults"}, call("reset_to_defaults")).leaf = true;
    local mtkwifi = require("mtkwifi")
    -- local profiles = mtkwifi.search_dev_and_profile()
    -- for devname,profile in pairs(profiles) do
    --     local cfgs = mtkwifi.load_profile(profile)
    --     if cfgs["VOW_Airtime_Fairness_En"] then
    --         entry({"admin", "mtk", "vow"}, template("admin_mtk/mtk_vow"), _("VoW / ATF / ATC"), 4)
    --         break
    --     end
    -- end

    -- Define map_help again here as same defination at top does not come under scope of luci library.
    local map_help
    if pcall(require, "map_helper") then
        map_help = require "map_helper"
    end
    if map_help then
        entry({"admin", "mtk", "multi_ap", "reset_to_default_easymesh"}, call("reset_to_default_easymesh")).leaf = true;
        entry({"admin", "mtk", "multi_ap"}, template("admin_mtk/mtk_wifi_multi_ap"), _("EasyMesh"), 5);
        entry({"admin", "mtk", "multi_ap", "map_cfg"}, call("map_cfg")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_device_role"}, call("get_device_role")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "trigger_mandate_steering_on_agent"}, call("trigger_mandate_steering_on_agent")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "trigger_back_haul_steering_on_agent"}, call("trigger_back_haul_steering_on_agent")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "trigger_wps_fh_agent"}, call("trigger_wps_fh_agent")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_runtime_topology"}, template("admin_mtk/mtk_wifi_map_runtime_topology")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_runtime_topology"}, call("get_runtime_topology")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_data_element"}, template("admin_mtk/mtk_wifi_map_data_element")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_channel_scan_result"}, template("admin_mtk/mtk_wifi_map_channel_scan_result")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_channel_planning_score"}, template("admin_mtk/mtk_wifi_map_channel_planning_score")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "trigger_multi_ap_on_boarding"}, call("trigger_multi_ap_on_boarding")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_client_capabilities"}, template("admin_mtk/mtk_wifi_map_client_capabilities")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_client_capabilities"}, call("get_client_capabilities")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_ap_capabilities"}, template("admin_mtk/mtk_wifi_map_ap_capabilities")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "trigger_uplink_ap_selection"}, call("trigger_uplink_ap_selection")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_bh_connection_status"}, call("get_bh_connection_status")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_sta_steering_progress"}, call("get_sta_steering_progress")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_al_mac"}, call("get_al_mac")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "apply_wifi_bh_priority"}, call("apply_wifi_bh_priority")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "apply_ap_steer_rssi_th"}, call("apply_ap_steer_rssi_th")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "apply_channel_utilization_th"}, call("apply_channel_utilization_th")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_sta_bh_interface"}, call("get_sta_bh_interface")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_ap_bh_inf_list"}, call("get_ap_bh_inf_list")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_ap_fh_inf_list"}, call("get_ap_fh_inf_list")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_fh_status_bss"}, template("admin_mtk/mtk_wifi_map_bssinfo")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_bh_link_metrics_ctrler"}, template("admin_mtk/mtk_wifi_map_bh_link_metrics")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "easymesh_bss_config_renew"}, template("admin_mtk/mtk_wifi_map_bss_cfg_renew")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "easymesh_bss_cfg"}, call("easymesh_bss_cfg")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "validate_add_easymesh_bss_req"}, call("validate_add_easymesh_bss_req")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "remove_easymesh_bss_cfg_req"}, call("remove_easymesh_bss_cfg_req")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "apply_easymesh_bss_cfg"}, call("apply_easymesh_bss_cfg")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "apply_force_ch_switch"}, call("apply_force_ch_switch")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "apply_user_preferred_channel"}, call("apply_user_preferred_channel")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "trigger_channel_planning_r2"}, call("trigger_channel_planning_r2")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "trigger_de_dump"}, call("trigger_de_dump")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_data_element"}, call("get_data_element")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "trigger_channel_scan"}, call("trigger_channel_scan")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_channel_stats"}, call("get_channel_stats")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_channel_planning_score"}, call("get_channel_planning_score")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_user_preferred_channel"}, call("get_user_preferred_channel")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "get_sp_rule_list"}, call("get_sp_rule_list")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "del_sp_rule"}, call("del_sp_rule")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "sp_rule_reorder"}, call("sp_rule_reorder")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "sp_rule_move"}, call("sp_rule_move")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "add_sp_rule"}, call("sp_rule_add")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "sp_config_done"}, call("sp_config_done")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "submit_dpp_uri"}, call("submit_dpp_uri")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "display_bootstrapping_uri"}, template("admin_mtk/mtk_wifi_map_display_bootstrapping_uri")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "start_dpp_onboarding"}, call("start_dpp_onboarding")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "generate_dpp_uri"}, call("generate_dpp_uri")).leaf = true;
        entry({"admin", "mtk", "multi_ap", "retrive_dpp_uri"}, call("retrive_dpp_uri")).leaf = true;
    end
end

function test()
    http.write_json(http.formvalue())
end

function exec_reboot()
    os.execute("rm -f /tmp/mtk/wifi/reboot_required >/dev/null 2>&1")
    os.execute("sync >/dev/null 2>&1")
    os.execute("reboot >/dev/null 2>&1")
end

function get_apply_status()
    local ret = {}

    if mtkwifi.is_child_active() then
        ret["status"] = "ON_PROGRESS"
    elseif mtkwifi.exists("/tmp/mtk/wifi/reboot_required") then
        -- If the "wifi restart" command can not re-install the driver; then, it will create
        -- "/tmp/mtk/wifi/reboot_required" file to indicate LuCI that the settings will be applied
        -- only after reboot of the device.
        -- Redirect "Reboot Device" web-page to get consent from the user to reboot the device.
        ret["status"] = "REBOOT"
    else
        ret["status"] = "DONE"
    end
    http.write_json(ret)
end

function __mtkwifi_save_profile(cfgs, path, isProfileSettingsAppliedToDriver)
    -- Create the applied settings backup file before saving the new profile settings only if it does not exist.
    if not mtkwifi.exists(mtkwifi.__profile_applied_settings_path(path)) then
        os.execute("cp -f "..path.." "..mtkwifi.__profile_applied_settings_path(path))
    end
    if isProfileSettingsAppliedToDriver then
        -- It means the some context based profile settings to be saved in DAT file is already applied to the driver.
        -- Find the profile settings which are not applied to the driver before saving the new profile settings
        local diff = mtkwifi.diff_profile(path)
        mtkwifi.save_profile(cfgs, path)
        -- If there are any settings which are not applied to the driver, then do NOT copy and WebUI will display the "need reload to apply changes" message
        -- Otherwise, copy the new profile settings and WebUI will NOT display the "need reload to apply changes" message
        if next(diff) == nil then
            os.execute("cp -f "..path.." "..mtkwifi.__profile_applied_settings_path(path))
        end
    else
        mtkwifi.save_profile(cfgs, path)
    end
end

local __mtkwifi_reload = function (devname)
    local wifi_restart = false
    local wifi_reload = false
    local profiles = mtkwifi.search_dev_and_profile()

    for dev,profile in pairs(profiles) do
        if not devname or devname == dev then
            local diff = mtkwifi.diff_profile(profile)
            local diff_easy = mtkwifi.diff_profile(mtkwifi.__write_easymesh_profile_path(), mtkwifi.__profile_applied_settings_path(mtkwifi.__write_easymesh_profile_path()))
            if not next(diff) and not next(diff_easy) then return end
            __process_settings_before_apply(dev, profile, diff)

            if diff.BssidNum or diff.WHNAT or diff.E2pAccessMode or diff.HT_RxStream or diff.HT_TxStream or diff.HE_LDPC or diff.WdsEnable then
                -- Addition or deletion of a vif requires re-installation of the driver.
                -- Change in WHNAT setting also requires re-installation of the driver.
                -- Driver will be re-installed by "wifi restart" command.
                wifi_restart = true
            else
                wifi_reload = true
            end

        end
    end

    if wifi_restart then
        os.execute("wifi restart "..(devname or ""))
        debug_write("wifi restart "..(devname or ""))
    elseif wifi_reload then
        os.execute("wifi reload "..(devname or ""))
        debug_write("wifi reload "..(devname or ""))
    end

    for dev,profile in pairs(profiles) do
        if not devname or devname == dev then
            -- keep a backup for this commit
            -- it will be used in mtkwifi.diff_profile()
            os.execute("cp -f "..profile.." "..mtkwifi.__profile_applied_settings_path(profile))
            debug_write("cp -f "..profile.." "..mtkwifi.__profile_applied_settings_path(profile))
        end
    end

    if map_help then
        local easymesh_applied_path = mtkwifi.__profile_applied_settings_path(mtkwifi.__read_easymesh_profile_path())
        os.execute("cp -f "..mtkwifi.__read_easymesh_profile_path().." "..easymesh_applied_path)
    end
end

function __process_settings_before_apply(devname, profile, diff)
    local devs = mtkwifi.get_all_devs()
    local cfgs = mtkwifi.load_profile(profile)
    __apply_wifi_wpsconf(devs, devname, cfgs, diff)
end

function chip_cfg(devname)
    local profiles = mtkwifi.search_dev_and_profile()
    assert(profiles[devname])
    local cfgs = mtkwifi.load_profile(profiles[devname])
    local devs = mtkwifi.get_all_devs()
    local dbdc_cfgs = {}
    local dev = {}
    dev = devs and devs[devname]

    for k,v in pairs(http.formvalue()) do
        if type(v) ~= type("") and type(v) ~= type(0) then
            nixio.syslog("err", "chip_cfg, invalid value type for "..k..","..type(v))
        elseif string.byte(k) == string.byte("_") then
            nixio.syslog("err", "chip_cfg, special: "..k.."="..v)
        else
            if dev.dbdc == true then
                dbdc_cfgs[k] = v or ""
            else
                cfgs[k] = v or ""
            end
        end
    end

    -- VOW
    -- ATC should actually be scattered into each SSID, but I'm just lazy.
    if cfgs.VOW_Airtime_Fairness_En then
    for i = 1,tonumber(cfgs.BssidNum) do
        __atc_tp     = http.formvalue("__atc_vif"..i.."_tp")     or "0"
        __atc_min_tp = http.formvalue("__atc_vif"..i.."_min_tp") or "0"
        __atc_max_tp = http.formvalue("__atc_vif"..i.."_max_tp") or "0"
        __atc_at     = http.formvalue("__atc_vif"..i.."_at")     or "0"
        __atc_min_at = http.formvalue("__atc_vif"..i.."_min_at") or "0"
        __atc_max_at = http.formvalue("__atc_vif"..i.."_max_at") or "0"

        nixio.syslog("info", "ATC.__atc_tp     ="..i..__atc_tp     );
        nixio.syslog("info", "ATC.__atc_min_tp ="..i..__atc_min_tp );
        nixio.syslog("info", "ATC.__atc_max_tp ="..i..__atc_max_tp );
        nixio.syslog("info", "ATC.__atc_at     ="..i..__atc_at     );
        nixio.syslog("info", "ATC.__atc_min_at ="..i..__atc_min_at );
        nixio.syslog("info", "ATC.__atc_max_at ="..i..__atc_max_at );

        dbdc_cfgs.VOW_Rate_Ctrl_En    = mtkwifi.token_set(cfgs.VOW_Rate_Ctrl_En,    i, __atc_tp)
        dbdc_cfgs.VOW_Group_Min_Rate  = mtkwifi.token_set(cfgs.VOW_Group_Min_Rate,  i, __atc_min_tp)
        dbdc_cfgs.VOW_Group_Max_Rate  = mtkwifi.token_set(cfgs.VOW_Group_Max_Rate,  i, __atc_max_tp)

        dbdc_cfgs.VOW_Airtime_Ctrl_En = mtkwifi.token_set(cfgs.VOW_Airtime_Ctrl_En, i, __atc_at)
        dbdc_cfgs.VOW_Group_Min_Ratio = mtkwifi.token_set(cfgs.VOW_Group_Min_Ratio, i, __atc_min_at)
        dbdc_cfgs.VOW_Group_Max_Ratiio = mtkwifi.token_set(cfgs.VOW_Group_Max_Ratio, i, __atc_max_at)

        cfgs.VOW_Rate_Ctrl_En    = mtkwifi.token_set(cfgs.VOW_Rate_Ctrl_En,    i, __atc_tp)
        cfgs.VOW_Group_Min_Rate  = mtkwifi.token_set(cfgs.VOW_Group_Min_Rate,  i, __atc_min_tp)
        cfgs.VOW_Group_Max_Rate  = mtkwifi.token_set(cfgs.VOW_Group_Max_Rate,  i, __atc_max_tp)

        cfgs.VOW_Airtime_Ctrl_En = mtkwifi.token_set(cfgs.VOW_Airtime_Ctrl_En, i, __atc_at)
        cfgs.VOW_Group_Min_Ratio = mtkwifi.token_set(cfgs.VOW_Group_Min_Ratio, i, __atc_min_at)
        cfgs.VOW_Group_Max_Ratio = mtkwifi.token_set(cfgs.VOW_Group_Max_Ratio, i, __atc_max_at)

    end

    dbdc_cfgs.VOW_RX_En = http.formvalue("VOW_RX_En") or "0"
    cfgs.VOW_RX_En = http.formvalue("VOW_RX_En") or "0"
    end

    if dev.dbdc == true then
        for devname, profile in pairs(profiles) do
            __mtkwifi_save_profile(dbdc_cfgs, profile, false)
        end
    else
        __mtkwifi_save_profile(cfgs, profiles[devname], false)
    end

    if http.formvalue("__apply") then
        mtkwifi.__run_in_child_env(__mtkwifi_reload, devname)
        local url_to_visit_after_reload = luci.dispatcher.build_url("admin", "mtk", "wifi", "chip_cfg_view",devname)
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",url_to_visit_after_reload))
    else
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "chip_cfg_view",devname))
    end

end

function dev_cfg(devname)
    local profiles = mtkwifi.search_dev_and_profile()
    assert(profiles[devname])
    local cfgs = mtkwifi.load_profile(profiles[devname])

    for k,v in pairs(http.formvalue()) do
        if type(v) ~= type("") and type(v) ~= type(0) then
            nixio.syslog("err", "dev_cfg, invalid value type for "..k..","..type(v))
        elseif string.byte(k) == string.byte("_") then
            nixio.syslog("err", "dev_cfg, special: "..k.."="..v)
        else
            cfgs[k] = v or ""
        end
    end

    if cfgs.Channel == "0" then -- Auto Channel Select
        cfgs.AutoChannelSelect = "3"
    else
        cfgs.AutoChannelSelect = "0"
    end

    if http.formvalue("__bw") == "20" then
        cfgs.HT_BW = 0
        cfgs.VHT_BW = 0
    elseif http.formvalue("__bw") == "40" then
        cfgs.HT_BW = 1
        cfgs.VHT_BW = 0
        cfgs.HT_BSSCoexistence = 0
    elseif http.formvalue("__bw") == "60" then
        cfgs.HT_BW = 1
        cfgs.VHT_BW = 0
        cfgs.HT_BSSCoexistence = 1
    elseif http.formvalue("__bw") == "80" then
        cfgs.HT_BW = 1
        cfgs.VHT_BW = 1
    elseif http.formvalue("__bw") == "160" then
        cfgs.HT_BW = 1
        cfgs.VHT_BW = 2
    elseif http.formvalue("__bw") == "161" then
        cfgs.HT_BW = 1
        cfgs.VHT_BW = 3
        cfgs.VHT_Sec80_Channel = http.formvalue("VHT_Sec80_Channel") or ""
    end

    if mtkwifi.band(string.split(cfgs.WirelessMode,";")[1]) == "5G" or mtkwifi.band(cfgs.WirelessMode) == "6G" then
        cfgs.CountryRegionABand = http.formvalue("__cr");
    else
        cfgs.CountryRegion = http.formvalue("__cr");
    end

    if http.formvalue("TxPower") then
        local txpower = tonumber(http.formvalue("TxPower"))
        if txpower < 100 then
            cfgs.PERCENTAGEenable=1
        else
            cfgs.PERCENTAGEenable=0
        end
    end
 
    local IndividualTWTSupport = tonumber(http.formvalue("IndividualTWTSupport"))
    if IndividualTWTSupport == 0 then
        cfgs.TWTResponder=0
        cfgs.TWTRequired=0
    elseif IndividualTWTSupport == 1 then
        cfgs.TWTResponder=1
        cfgs.TWTRequired=0
    else
        cfgs.TWTResponder=1
        cfgs.TWTRequired=1
    end

    local mimo = http.formvalue("__mimo")
    if mimo == "0" then
        cfgs.ETxBfEnCond=1
        cfgs.MUTxRxEnable=0
        cfgs.ITxBfEn=0
    elseif mimo == "1" then
        cfgs.ETxBfEnCond=0
        cfgs.MUTxRxEnable=0
        cfgs.ITxBfEn=1
    elseif mimo == "2" then
        cfgs.ETxBfEnCond=1
        cfgs.MUTxRxEnable=0
        cfgs.ITxBfEn=1
    elseif mimo == "3" then
        cfgs.ETxBfEnCond=1
        if tonumber(cfgs.ApCliEnable) == 1 then
            cfgs.MUTxRxEnable=3
        else
            cfgs.MUTxRxEnable=1
        end
        cfgs.ITxBfEn=0
    elseif mimo == "4" then
        cfgs.ETxBfEnCond=1
        if tonumber(cfgs.ApCliEnable) == 1 then
            cfgs.MUTxRxEnable=3
        else
            cfgs.MUTxRxEnable=1
        end
        cfgs.ITxBfEn=1
    else
        cfgs.ETxBfEnCond=0
        cfgs.MUTxRxEnable=0
        cfgs.ITxBfEn=0
    end

--    if cfgs.ApCliEnable == "1" then
--        cfgs.Channel = http.formvalue("__apcli_channel")
--    end

    -- WDS
    -- http.write_json(http.formvalue())
    __mtkwifi_save_profile(cfgs, profiles[devname], false)

    if http.formvalue("__apply") then
        mtkwifi.__run_in_child_env(__mtkwifi_reload, devname)
        local url_to_visit_after_reload = luci.dispatcher.build_url("admin", "mtk", "wifi", "dev_cfg_view",devname)
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",url_to_visit_after_reload))
    else
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "dev_cfg_view",devname))
    end
end

function dev_cfg_raw(devname)
    -- http.write_json(http.formvalue())
    local profiles = mtkwifi.search_dev_and_profile()
    assert(profiles[devname])

    local raw = http.formvalue("raw")
    raw = string.gsub(raw, "\r\n", "\n")
    local cfgs = mtkwifi.load_profile(nil, raw)
    __mtkwifi_save_profile(cfgs, profiles[devname], false)

    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "dev_cfg_view", devname))
end

function __delete_mbss_para(cfgs, vif_idx)
    debug_write(vif_idx)
    cfgs["WPAPSK"..vif_idx]=""
    cfgs["Key1Type"]=mtkwifi.token_set(cfgs["Key1Type"],vif_idx,"")
    cfgs["Key2Type"]=mtkwifi.token_set(cfgs["Key2Type"],vif_idx,"")
    cfgs["Key3Type"]=mtkwifi.token_set(cfgs["Key3Type"],vif_idx,"")
    cfgs["Key4Type"]=mtkwifi.token_set(cfgs["Key4Type"],vif_idx,"")
    cfgs["RADIUS_Server"]=mtkwifi.token_set(cfgs["RADIUS_Server"],vif_idx,"")
    cfgs["RADIUS_Port"]=mtkwifi.token_set(cfgs["RADIUS_Port"],vif_idx,"")
    cfgs["RADIUS_Key"..vif_idx]=""
    cfgs["DefaultKeyID"]=mtkwifi.token_set(cfgs["DefaultKeyID"],vif_idx,"")
    cfgs["IEEE8021X"]=mtkwifi.token_set(cfgs["IEEE8021X"],vif_idx,"")
    cfgs["WscConfMode"]=mtkwifi.token_set(cfgs["WscConfMode"],vif_idx,"")
    cfgs["PreAuth"]=mtkwifi.token_set(cfgs["PreAuth"],vif_idx,"")
    cfgs["HT_STBC"] = mtkwifi.token_set(cfgs["HT_STBC"],vif_idx,"")
    cfgs["HT_LDPC"] = mtkwifi.token_set(cfgs["HT_LDPC"],vif_idx,"")
    cfgs["VHT_STBC"] = mtkwifi.token_set(cfgs["VHT_STBC"],vif_idx,"")
    cfgs["VHT_LDPC"] = mtkwifi.token_set(cfgs["VHT_LDPC"],vif_idx,"")
    cfgs["HideSSID"]=mtkwifi.token_set(cfgs["HideSSID"],vif_idx,"")
    cfgs["NoForwarding"]=mtkwifi.token_set(cfgs["NoForwarding"],vif_idx,"")
    cfgs["WmmCapable"]=mtkwifi.token_set(cfgs["WmmCapable"],vif_idx,"")
    cfgs["TxRate"]=mtkwifi.token_set(cfgs["TxRate"],vif_idx,"")
    cfgs["RekeyInterval"]=mtkwifi.token_set(cfgs["RekeyInterval"],vif_idx,"")
    cfgs["AuthMode"]=mtkwifi.token_set(cfgs["AuthMode"],vif_idx,"")
    cfgs["EncrypType"]=mtkwifi.token_set(cfgs["EncrypType"],vif_idx,"")
    cfgs["session_timeout_interval"]=mtkwifi.token_set(cfgs["session_timeout_interval"],vif_idx,"")
    cfgs["WscModeOption"]=mtkwifi.token_set(cfgs["WscModeOption"],vif_idx,"")
    cfgs["RekeyMethod"]=mtkwifi.token_set(cfgs["RekeyMethod"],vif_idx,"")
    cfgs["PMFMFPC"] = mtkwifi.token_set(cfgs["PMFMFPC"],vif_idx,"")
    cfgs["PMFMFPR"] = mtkwifi.token_set(cfgs["PMFMFPR"],vif_idx,"")
    cfgs["PMFSHA256"] = mtkwifi.token_set(cfgs["PMFSHA256"],vif_idx,"")
    cfgs["PMKCachePeriod"] = mtkwifi.token_set(cfgs["PMKCachePeriod"],vif_idx,"")
    cfgs["Wapiifname"] = mtkwifi.token_set(cfgs["Wapiifname"],vif_idx,"")
    cfgs["RRMEnable"] = mtkwifi.token_set(cfgs["RRMEnable"],vif_idx,"")
    cfgs["DLSCapable"] = mtkwifi.token_set(cfgs["DLSCapable"],vif_idx,"")
    cfgs["APSDCapable"] = mtkwifi.token_set(cfgs["APSDCapable"],vif_idx,"")
    cfgs["FragThreshold"] = mtkwifi.token_set(cfgs["FragThreshold"],vif_idx,"")
    cfgs["RTSThreshold"] = mtkwifi.token_set(cfgs["RTSThreshold"],vif_idx,"")
    cfgs["VHT_SGI"] = mtkwifi.token_set(cfgs["VHT_SGI"],vif_idx,"")
    cfgs["VHT_BW_SIGNAL"] = mtkwifi.token_set(cfgs["VHT_BW_SIGNAL"],vif_idx,"")
    cfgs["HT_PROTECT"] = mtkwifi.token_set(cfgs["HT_PROTECT"],vif_idx,"")
    cfgs["HT_GI"] = mtkwifi.token_set(cfgs["HT_GI"],vif_idx,"")
    cfgs["HT_OpMode"] = mtkwifi.token_set(cfgs["HT_OpMode"],vif_idx,"")
    cfgs["HT_TxStream"] = mtkwifi.token_set(cfgs["HT_TxStream"],vif_idx,"")
    cfgs["HT_RxStream"] = mtkwifi.token_set(cfgs["HT_RxStream"],vif_idx,"")
    cfgs["HT_AMSDU"] = mtkwifi.token_set(cfgs["HT_AMSDU"],vif_idx,"")
    cfgs["HT_AutoBA"] = mtkwifi.token_set(cfgs["HT_AutoBA"],vif_idx,"")
    cfgs["IgmpSnEnable"] = mtkwifi.token_set(cfgs["IgmpSnEnable"],vif_idx,"")
    cfgs["WirelessMode"] = mtkwifi.token_set(cfgs["WirelessMode"],vif_idx,"")
    cfgs["WdsEnable"] = mtkwifi.token_set(cfgs["WdsEnable"],vif_idx,"")
    cfgs["MuOfdmaDlEnable"] = mtkwifi.token_set(cfgs["MuOfdmaDlEnable"],vif_idx,"")
    cfgs["MuOfdmaUlEnable"] = mtkwifi.token_set(cfgs["MuOfdmaUlEnable"],vif_idx,"")
    cfgs["MuMimoDlEnable"] = mtkwifi.token_set(cfgs["MuMimoDlEnable"],vif_idx,"")
    cfgs["MuMimoUlEnable"] = mtkwifi.token_set(cfgs["MuMimoUlEnable"],vif_idx,"")

end

function vif_del(dev, vif)
    debug_write("vif_del("..dev..vif..")")
    local devname,vifname = dev, vif
    debug_write("devname="..devname)
    debug_write("vifname="..vifname)
    local devs = mtkwifi.get_all_devs()
    local idx = devs[devname]["vifs"][vifname].vifidx -- or tonumber(string.match(vifname, "%d+")) + 1
    debug_write("idx="..idx, devname, vifname)
    local profile = devs[devname].profile 
    assert(profile)
    if idx and tonumber(idx) >= 0 then
        local cfgs = mtkwifi.load_profile(profile)
        __delete_mbss_para(cfgs, idx)
        if cfgs then
            debug_write("ssid"..idx.."="..cfgs["SSID"..idx].."<br>")
            cfgs["SSID"..idx] = ""
            debug_write("ssid"..idx.."="..cfgs["SSID"..idx].."<br>")
            debug_write("wpapsk"..idx.."="..cfgs["WPAPSK"..idx].."<br>")
            cfgs["WPAPSK"..idx] = ""
            local ssidlist = {}
            local j = 1
            for i = 1,16 do
                if cfgs["SSID"..i] ~= "" then
                    ssidlist[j] =  cfgs["SSID"..i]
                    j = j + 1
                end
            end
            for i,v in ipairs(ssidlist) do
                debug_write("ssidlist"..i.."="..v)
            end
            debug_write("cfgs.BssidNum="..cfgs.BssidNum.." #ssidlist="..#ssidlist)
            assert(tonumber(cfgs.BssidNum) == #ssidlist + 1, "BssidNum="..cfgs.BssidNum.." SSIDlist="..#ssidlist..", BssidNum count does not match with SSIDlist count.")
            cfgs.BssidNum = #ssidlist
            for i = 1,16 do
                if i <= cfgs.BssidNum then
                    cfgs["SSID"..i] = ssidlist[i]
                elseif cfgs["SSID"..i] then
                    cfgs["SSID"..i] = ""
                end
            end

            __mtkwifi_save_profile(cfgs, profile, false)
        else
            debug_write(profile.." cannot be found!")
        end
    end
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi"))
end

function vif_disable(iface)
    os.execute("ifconfig "..iface.." down")
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi"))
end

function vif_enable(iface)
    os.execute("ifconfig "..iface.." up")
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi"))
end


--[[
-- security config in mtk wifi is quite complicated!
-- cfgs listed below are attached with vif and combined like "0;0;0;0". They need specicial treatment.
        TxRate, WmmCapable, NoForwarding,
        HideSSID, IEEE8021X, PreAuth,
        AuthMode, EncrypType, RekeyMethod,
        RekeyInterval, PMKCachePeriod,
        DefaultKeyId, Key{n}Type, HT_EXTCHA,
        RADIUS_Server, RADIUS_Port,
]]

local function conf_wep_keys(cfgs,vifidx)
    cfgs.DefaultKeyID = mtkwifi.token_set(cfgs.DefaultKeyID, vifidx, http.formvalue("__DefaultKeyID") or 1)
    cfgs["Key1Str"..vifidx]  = http.formvalue("Key1Str"..vifidx)
    cfgs["Key2Str"..vifidx]  = http.formvalue("Key2Str"..vifidx)
    cfgs["Key3Str"..vifidx]  = http.formvalue("Key3Str"..vifidx)
    cfgs["Key4Str"..vifidx]  = http.formvalue("Key4Str"..vifidx)

    cfgs["Key1Type"]=mtkwifi.token_set(cfgs["Key1Type"],vifidx, http.formvalue("WEP1Type"..vifidx))
    cfgs["Key2Type"]=mtkwifi.token_set(cfgs["Key2Type"],vifidx, http.formvalue("WEP2Type"..vifidx))
    cfgs["Key3Type"]=mtkwifi.token_set(cfgs["Key3Type"],vifidx, http.formvalue("WEP3Type"..vifidx))
    cfgs["Key4Type"]=mtkwifi.token_set(cfgs["Key4Type"],vifidx, http.formvalue("WEP4Type"..vifidx))

    return cfgs
end

local function __security_cfg(cfgs, vif_idx)
    debug_write("__security_cfg, before, HideSSID="..tostring(cfgs.HideSSID))
    debug_write("__security_cfg, before, NoForwarding="..tostring(cfgs.NoForwarding))
    debug_write("__security_cfg, before, WmmCapable="..tostring(cfgs.WmmCapable))
    debug_write("__security_cfg, before, TxRate="..tostring(cfgs.TxRate))
    debug_write("__security_cfg, before, RekeyInterval="..tostring(cfgs.RekeyInterval))
    debug_write("__security_cfg, before, AuthMode="..tostring(cfgs.AuthMode))
    debug_write("__security_cfg, before, EncrypType="..tostring(cfgs.EncrypType))
    debug_write("__security_cfg, before, WscModeOption="..tostring(cfgs.WscModeOption))
    debug_write("__security_cfg, before, RekeyMethod="..tostring(cfgs.RekeyMethod))
    debug_write("__security_cfg, before, IEEE8021X="..tostring(cfgs.IEEE8021X))
    debug_write("__security_cfg, before, DefaultKeyID="..tostring(cfgs.DefaultKeyID))
    debug_write("__security_cfg, before, PMFMFPC="..tostring(cfgs.PMFMFPC))
    debug_write("__security_cfg, before, PMFMFPR="..tostring(cfgs.PMFMFPR))
    debug_write("__security_cfg, before, PMFSHA256="..tostring(cfgs.PMFSHA256))
    debug_write("__security_cfg, before, RADIUS_Server="..tostring(cfgs.RADIUS_Server))
    debug_write("__security_cfg, before, RADIUS_Port="..tostring(cfgs.RADIUS_Port))
    debug_write("__security_cfg, before, session_timeout_interval="..tostring(cfgs.session_timeout_interval))
    debug_write("__security_cfg, before, PMKCachePeriod="..tostring(cfgs.PMKCachePeriod))
    debug_write("__security_cfg, before, PreAuth="..tostring(cfgs.PreAuth))
    debug_write("__security_cfg, before, Wapiifname="..tostring(cfgs.Wapiifname))

    -- Reset/Clear all necessary settings here. Later, these settings will be set as per AuthMode.
    cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "DISABLE")
    cfgs.IEEE8021X = mtkwifi.token_set(cfgs.IEEE8021X, vif_idx, "0")
    cfgs.PMFMFPC = mtkwifi.token_set(cfgs.PMFMFPC, vif_idx, "0")
    cfgs.PMFMFPR = mtkwifi.token_set(cfgs.PMFMFPR, vif_idx, "0")
    cfgs.PMFSHA256 = mtkwifi.token_set(cfgs.PMFSHA256, vif_idx, "0")

    -- Update the settings which are not dependent on AuthMode
    cfgs.HideSSID = mtkwifi.token_set(cfgs.HideSSID, vif_idx, http.formvalue("__hidessid") or "0")
    cfgs.NoForwarding = mtkwifi.token_set(cfgs.NoForwarding, vif_idx, http.formvalue("__noforwarding") or "0")
    cfgs.WmmCapable = mtkwifi.token_set(cfgs.WmmCapable, vif_idx, http.formvalue("__wmmcapable") or "0")
    cfgs.TxRate = mtkwifi.token_set(cfgs.TxRate, vif_idx, http.formvalue("__txrate") or "0");
    cfgs.RekeyInterval = mtkwifi.token_set(cfgs.RekeyInterval, vif_idx, http.formvalue("__rekeyinterval") or "0");

    local __authmode = http.formvalue("__authmode") or "Disable"
    cfgs.AuthMode = mtkwifi.token_set(cfgs.AuthMode, vif_idx, __authmode)

    if __authmode == "Disable" then
        cfgs.AuthMode = mtkwifi.token_set(cfgs.AuthMode, vif_idx, "OPEN")
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "NONE")

    elseif __authmode == "OPEN" or __authmode == "SHARED" or __authmode == "WEPAUTO" then
        cfgs.WscModeOption = "0"
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "WEP")
        cfgs = conf_wep_keys(cfgs,vif_idx)

    elseif __authmode == "Enhanced Open" then
        cfgs.AuthMode = mtkwifi.token_set(cfgs.AuthMode, vif_idx, "OWE")
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "AES")
        cfgs.PMFMFPC = mtkwifi.token_set(cfgs.PMFMFPC, vif_idx, "1")
        cfgs.PMFMFPR = mtkwifi.token_set(cfgs.PMFMFPR, vif_idx, "1")
        cfgs.PMFSHA256 = mtkwifi.token_set(cfgs.PMFSHA256, vif_idx, "0")

    elseif __authmode == "WPAPSK"  then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, http.formvalue("__encrypttype") or "AES")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")

    elseif __authmode == "WPAPSKWPA2PSK" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, http.formvalue("__encrypttype") or "AES")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")
        cfgs.WpaMixPairCipher = "WPA_TKIP_WPA2_AES"

    elseif __authmode == "WPA2PSK" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, http.formvalue("__encrypttype") or "AES")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")
        -- for DOT11W_PMF_SUPPORT
        cfgs.PMFMFPC = mtkwifi.token_set(cfgs.PMFMFPC, vif_idx, http.formvalue("__pmfmfpc") or "0")
        cfgs.PMFMFPR = mtkwifi.token_set(cfgs.PMFMFPR, vif_idx, http.formvalue("__pmfmfpr") or "0")
        cfgs.PMFSHA256 = mtkwifi.token_set(cfgs.PMFSHA256, vif_idx, http.formvalue("__pmfsha256") or "0")

    elseif __authmode == "WPA3PSK" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "AES")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")
        -- for DOT11W_PMF_SUPPORT
        cfgs.PMFMFPC = mtkwifi.token_set(cfgs.PMFMFPC, vif_idx, "1")
        cfgs.PMFMFPR = mtkwifi.token_set(cfgs.PMFMFPR, vif_idx, "1")
        cfgs.PMFSHA256 = mtkwifi.token_set(cfgs.PMFSHA256, vif_idx, "0")

    elseif __authmode == "WPA2PSKWPA3PSK" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "AES")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")
        -- for DOT11W_PMF_SUPPORT
        cfgs.PMFMFPC = mtkwifi.token_set(cfgs.PMFMFPC, vif_idx, "1")
        cfgs.PMFMFPR = mtkwifi.token_set(cfgs.PMFMFPR, vif_idx, "0")
        cfgs.PMFSHA256 = mtkwifi.token_set(cfgs.PMFSHA256, vif_idx, "0")

    elseif __authmode == "WPA2" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, http.formvalue("__encrypttype") or "AES")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")
        cfgs.RADIUS_Server = mtkwifi.token_set(cfgs.RADIUS_Server, vif_idx, http.formvalue("__radius_server") or "0")
        cfgs.RADIUS_Port = mtkwifi.token_set(cfgs.RADIUS_Port, vif_idx, http.formvalue("__radius_port") or "0")
        cfgs.session_timeout_interval = mtkwifi.token_set(cfgs.session_timeout_interval, vif_idx, http.formvalue("__session_timeout_interval") or "0")
        cfgs.PMKCachePeriod = mtkwifi.token_set(cfgs.PMKCachePeriod, vif_idx, http.formvalue("__pmkcacheperiod") or "0")
        cfgs.PreAuth = mtkwifi.token_set(cfgs.PreAuth, vif_idx, http.formvalue("__preauth") or "0")
        -- for DOT11W_PMF_SUPPORT
        cfgs.PMFMFPC = mtkwifi.token_set(cfgs.PMFMFPC, vif_idx, http.formvalue("__pmfmfpc") or "0")
        cfgs.PMFMFPR = mtkwifi.token_set(cfgs.PMFMFPR, vif_idx, http.formvalue("__pmfmfpr") or "0")
        cfgs.PMFSHA256 = mtkwifi.token_set(cfgs.PMFSHA256, vif_idx, http.formvalue("__pmfsha256") or "0")

    elseif __authmode == "WPA3" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "AES")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")
        cfgs.RADIUS_Server = mtkwifi.token_set(cfgs.RADIUS_Server, vif_idx, http.formvalue("__radius_server") or "0")
        cfgs.RADIUS_Port = mtkwifi.token_set(cfgs.RADIUS_Port, vif_idx, http.formvalue("__radius_port") or "0")
        cfgs.session_timeout_interval = mtkwifi.token_set(cfgs.session_timeout_interval, vif_idx, http.formvalue("__session_timeout_interval") or "0")
        cfgs.PMKCachePeriod = mtkwifi.token_set(cfgs.PMKCachePeriod, vif_idx, http.formvalue("__pmkcacheperiod") or "0")
        cfgs.PreAuth = mtkwifi.token_set(cfgs.PreAuth, vif_idx, http.formvalue("__preauth") or "0")
        -- for DOT11W_PMF_SUPPORT
        cfgs.PMFMFPC = mtkwifi.token_set(cfgs.PMFMFPC, vif_idx, "1")
        cfgs.PMFMFPR = mtkwifi.token_set(cfgs.PMFMFPR, vif_idx, "1")
        cfgs.PMFSHA256 = mtkwifi.token_set(cfgs.PMFSHA256, vif_idx, "0")

    elseif __authmode == "WPA3-192-bit" then
        cfgs.AuthMode = mtkwifi.token_set(cfgs.AuthMode, vif_idx, "WPA3-192")
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "GCMP256")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")
        cfgs.RADIUS_Server = mtkwifi.token_set(cfgs.RADIUS_Server, vif_idx, http.formvalue("__radius_server") or "0")
        cfgs.RADIUS_Port = mtkwifi.token_set(cfgs.RADIUS_Port, vif_idx, http.formvalue("__radius_port") or "0")
        cfgs.session_timeout_interval = mtkwifi.token_set(cfgs.session_timeout_interval, vif_idx, http.formvalue("__session_timeout_interval") or "0")
        cfgs.PMKCachePeriod = mtkwifi.token_set(cfgs.PMKCachePeriod, vif_idx, http.formvalue("__pmkcacheperiod") or "0")
        cfgs.PreAuth = mtkwifi.token_set(cfgs.PreAuth, vif_idx, http.formvalue("__preauth") or "0")
        -- for DOT11W_PMF_SUPPORT
        cfgs.PMFMFPC = mtkwifi.token_set(cfgs.PMFMFPC, vif_idx, "1")
        cfgs.PMFMFPR = mtkwifi.token_set(cfgs.PMFMFPR, vif_idx, "1")
        cfgs.PMFSHA256 = mtkwifi.token_set(cfgs.PMFSHA256, vif_idx, "0")

    elseif __authmode == "WPA1WPA2" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, http.formvalue("__encrypttype") or "AES")
        cfgs.RekeyMethod = mtkwifi.token_set(cfgs.RekeyMethod, vif_idx, "TIME")
        cfgs.RADIUS_Server = mtkwifi.token_set(cfgs.RADIUS_Server, vif_idx, http.formvalue("__radius_server") or "0")
        cfgs.RADIUS_Port = mtkwifi.token_set(cfgs.RADIUS_Port, vif_idx, http.formvalue("__radius_port") or "1812")
        cfgs.session_timeout_interval = mtkwifi.token_set(cfgs.session_timeout_interval, vif_idx, http.formvalue("__session_timeout_interval") or "0")
        cfgs.PMKCachePeriod = mtkwifi.token_set(cfgs.PMKCachePeriod, vif_idx, http.formvalue("__pmkcacheperiod") or "0")
        cfgs.PreAuth = mtkwifi.token_set(cfgs.PreAuth, vif_idx, http.formvalue("__preauth") or "0")

    elseif __authmode == "IEEE8021X" then
        cfgs.AuthMode = mtkwifi.token_set(cfgs.AuthMode, vif_idx, "OPEN")
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, http.formvalue("__8021x_wep") and "WEP" or "NONE")
        cfgs.IEEE8021X = mtkwifi.token_set(cfgs.IEEE8021X, vif_idx, "1")
        cfgs.RADIUS_Server = mtkwifi.token_set(cfgs.RADIUS_Server, vif_idx, http.formvalue("__radius_server") or "0")
        cfgs.RADIUS_Port = mtkwifi.token_set(cfgs.RADIUS_Port, vif_idx, http.formvalue("__radius_port") or "0")
        cfgs.session_timeout_interval = mtkwifi.token_set(cfgs.session_timeout_interval, vif_idx, http.formvalue("__session_timeout_interval") or "0")

    elseif __authmode == "WAICERT" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "SMS4")
        cfgs.Wapiifname = mtkwifi.token_set(cfgs.Wapiifname, vif_idx, "br-lan")
        -- cfgs.wapicert_asipaddr
        -- cfgs.WapiAsPort
        -- cfgs.wapicert_ascert
        -- cfgs.wapicert_usercert

    elseif __authmode == "WAIPSK" then
        cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, vif_idx, "SMS4")
        -- cfgs.wapipsk_keytype
        -- cfgs.wapipsk_prekey
    end

    debug_write("__security_cfg, after, HideSSID="..tostring(cfgs.HideSSID))
    debug_write("__security_cfg, after, NoForwarding="..tostring(cfgs.NoForwarding))
    debug_write("__security_cfg, after, WmmCapable="..tostring(cfgs.WmmCapable))
    debug_write("__security_cfg, after, TxRate="..tostring(cfgs.TxRate))
    debug_write("__security_cfg, after, RekeyInterval="..tostring(cfgs.RekeyInterval))
    debug_write("__security_cfg, after, AuthMode="..tostring(cfgs.AuthMode))
    debug_write("__security_cfg, after, EncrypType="..tostring(cfgs.EncrypType))
    debug_write("__security_cfg, after, WscModeOption="..tostring(cfgs.WscModeOption))
    debug_write("__security_cfg, after, RekeyMethod="..tostring(cfgs.RekeyMethod))
    debug_write("__security_cfg, after, IEEE8021X="..tostring(cfgs.IEEE8021X))
    debug_write("__security_cfg, after, DefaultKeyID="..tostring(cfgs.DefaultKeyID))
    debug_write("__security_cfg, after, PMFMFPC="..tostring(cfgs.PMFMFPC))
    debug_write("__security_cfg, after, PMFMFPR="..tostring(cfgs.PMFMFPR))
    debug_write("__security_cfg, after, PMFSHA256="..tostring(cfgs.PMFSHA256))
    debug_write("__security_cfg, after, RADIUS_Server="..tostring(cfgs.RADIUS_Server))
    debug_write("__security_cfg, after, RADIUS_Port="..tostring(cfgs.RADIUS_Port))
    debug_write("__security_cfg, after, session_timeout_interval="..tostring(cfgs.session_timeout_interval))
    debug_write("__security_cfg, after, PMKCachePeriod="..tostring(cfgs.PMKCachePeriod))
    debug_write("__security_cfg, after, PreAuth="..tostring(cfgs.PreAuth))
    debug_write("__security_cfg, after, Wapiifname="..tostring(cfgs.Wapiifname))
end

function initialize_multiBssParameters(cfgs,vif_idx)
    cfgs["WPAPSK"..vif_idx]="12345678"
    cfgs["Key1Type"]=mtkwifi.token_set(cfgs["Key1Type"],vif_idx,"0")
    cfgs["Key2Type"]=mtkwifi.token_set(cfgs["Key2Type"],vif_idx,"0")
    cfgs["Key3Type"]=mtkwifi.token_set(cfgs["Key3Type"],vif_idx,"0")
    cfgs["Key4Type"]=mtkwifi.token_set(cfgs["Key4Type"],vif_idx,"0")
    cfgs["RADIUS_Server"]=mtkwifi.token_set(cfgs["RADIUS_Server"],vif_idx,"0")
    cfgs["RADIUS_Port"]=mtkwifi.token_set(cfgs["RADIUS_Port"],vif_idx,"1812")
    cfgs["RADIUS_Key"..vif_idx]="ralink"
    cfgs["DefaultKeyID"]=mtkwifi.token_set(cfgs["DefaultKeyID"],vif_idx,"1")
    cfgs["IEEE8021X"]=mtkwifi.token_set(cfgs["IEEE8021X"],vif_idx,"0")
    cfgs["WscConfMode"]=mtkwifi.token_set(cfgs["WscConfMode"],vif_idx,"0")
    cfgs["PreAuth"]=mtkwifi.token_set(cfgs["PreAuth"],vif_idx,"0")
    return cfgs
end

function __wps_ap_pbc_start_all(ifname)
    os.execute("iwpriv "..ifname.." set WscMode=2");
    os.execute("iwpriv "..ifname.." set WscGetConf=1");
end

function __wps_ap_pin_start_all(ifname, pincode)
    os.execute("iwpriv "..ifname.." set WscMode=1")
    os.execute("iwpriv "..ifname.." set WscPinCode="..pincode)
    os.execute("iwpriv "..ifname.." set WscGetConf=1")
end

local __restart_miniupnpd = function (devName,ifName)
    if pcall(require, "wifi_services") then
        -- OpenWRT
        assert(type(devName) == type(""))
        assert(type(ifName) == type(""))
        local wifi_service = require("wifi_services")
        debug_write("Call miniupnpd_chk() of wifi_services module")
        miniupnpd_chk(devName,ifName,wifi_service)
    else
        -- LSDK
        debug_write("Execute miniupnpd.sh script!")
        os.execute("miniupnpd.sh init")
    end
end

local __restart_hotspot_daemon = function ()
    os.execute("killall hs")
    os.execute("rm -rf /tmp/hotspot*")
    -- As this function is executed in child environment, there is no need to spawn it using fork-exec method.
    os.execute("hs -d 1 -v 2 -f/etc_ro/hotspot_ap.conf")
end

local __restart_8021x = function (devName,ifName)
    if pcall(require, "wifi_services") then
        -- OpenWRT
        assert(type(devName) == type(""))
        assert(type(ifName) == type(""))
        local ifPrefix = string.match(ifName,"([a-z]+)")
        assert(type(ifPrefix) == type(""))
        local wifi_service = require("wifi_services")
        debug_write("Call d8021xd_chk() of wifi_services module")
        d8021xd_chk(devName,ifPrefix,ifPrefix.."0",true)
    else
        -- LSDK
        debug_write("Call mtkwifi.restart_8021x()")
        mtkwifi.restart_8021x(devName)
    end
end

--Landen: CP functions from wireless for Ajax, reloading page is not required when DBDC ssid changed.
local __restart_all_daemons = function (devName,ifName)
    __restart_8021x(devName,ifName)
    __restart_hotspot_daemon()
    __restart_miniupnpd(devName,ifName)
end

function __apply_wifi_wpsconf(devs, devname, cfgs, diff)
    local saved = cfgs.WscConfMode and cfgs.WscConfMode:gsub(";-(%d);-","%1") or ""
    local applied = diff.WscConfMode and diff["WscConfMode"][2]:gsub(";-(%d);-","%1") or ""
    local num_ifs = tonumber(cfgs.BssidNum) or 0

    for idx=1, num_ifs do
        local ifname = devs[devname]["vifs"][idx]["vifname"]
        if mtkwifi.__any_wsc_enabled(saved:sub(idx,idx)) == 1 then
            cfgs.WscConfStatus = mtkwifi.token_set(cfgs.WscConfStatus, idx, "2")
        else
            cfgs.WscConfStatus = mtkwifi.token_set(cfgs.WscConfStatus, idx, "1")
        end
        if (diff.WscConfMode) and saved:sub(idx,idx) ~= applied:sub(idx,idx) then
            cfgs = mtkwifi.__restart_if_wps(devname, ifname, cfgs)
        end
    end

    -- __mtkwifi_save_profile() is called outside the loop because it is a high time consuming function.
    __mtkwifi_save_profile(cfgs, devs[devname]["profile"], false)

    if diff.WscConfMode then
        for idx=1, num_ifs do
            local ifname = devs[devname]["vifs"][idx]["vifname"]
            if saved:sub(idx,idx) ~= applied:sub(idx,idx) then
                __restart_miniupnpd(devname, ifname)
            end
        end
    end
end

function __set_wifi_wpsconf(cfgs, wsc_enable, vif_idx)
    debug_write("__set_wifi_wpsconf : wsc_enable = ",wsc_enable)
    if(wsc_enable == "1") then
        cfgs["WscConfMode"] = mtkwifi.token_set(cfgs["WscConfMode"], vif_idx, "7")
    else
        cfgs["WscConfMode"] = mtkwifi.token_set(cfgs["WscConfMode"], vif_idx, "0")
    end
    if(((http.formvalue("__authmode")=="OPEN") and
        (http.formvalue("__encrypttype") == "WEP")) or
       (http.formvalue("__hidessid") == "1")) then
        cfgs.WscConfMode = mtkwifi.token_set(cfgs.WscConfMode, vif_idx, "0")
    end
    debug_write("__set_wifi_wpsconf : WscConfMode = ",cfgs["WscConfMode"])
end

function __update_mbss_para(cfgs, vif_idx)
    debug_write(vif_idx)
    cfgs.HT_STBC = mtkwifi.token_set(cfgs.HT_STBC, vif_idx, http.formvalue("__ht_stbc") or "0")
    cfgs.HT_LDPC = mtkwifi.token_set(cfgs.HT_LDPC, vif_idx, http.formvalue("__ht_ldpc") or "0")
    cfgs.VHT_STBC = mtkwifi.token_set(cfgs.VHT_STBC, vif_idx, http.formvalue("__vht_stbc") or "0")
    cfgs.VHT_LDPC = mtkwifi.token_set(cfgs.VHT_LDPC, vif_idx, http.formvalue("__vht_ldpc") or "0")
    cfgs.DLSCapable = mtkwifi.token_set(cfgs.DLSCapable, vif_idx, http.formvalue("__dls_capable") or "0")
    cfgs.APSDCapable = mtkwifi.token_set(cfgs.APSDCapable, vif_idx, http.formvalue("__apsd_capable") or "0")
    cfgs.FragThreshold = mtkwifi.token_set(cfgs.FragThreshold, vif_idx, http.formvalue("__frag_threshold") or "0")
    cfgs.RTSThreshold = mtkwifi.token_set(cfgs.RTSThreshold, vif_idx, http.formvalue("__rts_threshold") or "0")
    cfgs.VHT_SGI = mtkwifi.token_set(cfgs.VHT_SGI, vif_idx, http.formvalue("__vht_sgi") or "0")
    cfgs.VHT_BW_SIGNAL = mtkwifi.token_set(cfgs.VHT_BW_SIGNAL, vif_idx, http.formvalue("__vht_bw_signal") or "0")
    cfgs.HT_PROTECT = mtkwifi.token_set(cfgs.HT_PROTECT, vif_idx, http.formvalue("__ht_protect") or "0")
    cfgs.HT_GI = mtkwifi.token_set(cfgs.HT_GI, vif_idx, http.formvalue("__ht_gi") or "0")
    cfgs.HT_OpMode = mtkwifi.token_set(cfgs.HT_OpMode, vif_idx, http.formvalue("__ht_opmode") or "0")
    cfgs.HT_AMSDU = mtkwifi.token_set(cfgs.HT_AMSDU, vif_idx, http.formvalue("__ht_amsdu") or "0")
    cfgs.HT_AutoBA = mtkwifi.token_set(cfgs.HT_AutoBA, vif_idx, http.formvalue("__ht_autoba") or "0")
    cfgs.IgmpSnEnable = mtkwifi.token_set(cfgs.IgmpSnEnable, vif_idx, http.formvalue("__igmp_snenable") or "0")
    cfgs.WirelessMode = mtkwifi.token_set(cfgs.WirelessMode, vif_idx, http.formvalue("__wirelessmode") or "0")
    cfgs.WdsEnable = mtkwifi.token_set(cfgs.WdsEnable, vif_idx, http.formvalue("__wdsenable") or "0")
    cfgs.MuOfdmaDlEnable = mtkwifi.token_set(cfgs.MuOfdmaDlEnable, vif_idx, http.formvalue("__muofdma_dlenable") or "0")
    cfgs.MuOfdmaUlEnable = mtkwifi.token_set(cfgs.MuOfdmaUlEnable, vif_idx, http.formvalue("__muofdma_ulenable") or "0")
    cfgs.MuMimoDlEnable = mtkwifi.token_set(cfgs.MuMimoDlEnable, vif_idx, http.formvalue("__mumimo_dlenable") or "0")
    cfgs.MuMimoUlEnable = mtkwifi.token_set(cfgs.MuMimoUlEnable, vif_idx, http.formvalue("__mumimo_ulenable") or "0")

end

function vif_cfg(dev, vif)
    local devname, vifname = dev, vif
    if not devname then devname = vif end
    debug_write("devname="..devname)
    debug_write("vifname="..(vifname or ""))
    local devs = mtkwifi.get_all_devs()
    local profile = devs[devname].profile
    assert(profile)

    --local ssid_index;
    --ssid_index = devs[devname]["vifs"][vifname].vifidx

    local cfgs = mtkwifi.load_profile(profile)

    for k,v in pairs(http.formvalue()) do
        if type(v) == type("") or type(v) == type(0) then
            nixio.syslog("debug", "post."..k.."="..tostring(v))
        else
            nixio.syslog("debug", "post."..k.." invalid, type="..type(v))
        end
    end

    -- sometimes vif_idx start from 0, like AccessPolicy0
    -- sometimes it starts from 1, like WPAPSK1. nice!
    local vif_idx
    local to_url
    if http.formvalue("__action") == "vif_cfg_view" then
        vif_idx = devs[devname]["vifs"][vifname].vifidx
        debug_write("vif_idx=", vif_idx, devname, vifname)
        to_url = luci.dispatcher.build_url("admin", "mtk", "wifi", "vif_cfg_view", devname, vifname)
    elseif http.formvalue("__action") == "vif_add_view" then
        cfgs.BssidNum = tonumber(cfgs.BssidNum) + 1
        vif_idx = tonumber(cfgs.BssidNum)
        to_url = luci.dispatcher.build_url("admin", "mtk", "wifi")
        -- initializing ; separated parameters for the new interface
        cfgs = initialize_multiBssParameters(cfgs, vif_idx)
    end
    assert(vif_idx)
    assert(to_url)
    -- "__" should not be the prefix of a name if user wants to copy form value data directly to the dat file variable
    for k,v in pairs(http.formvalue()) do
        if type(v) ~= type("") and type(v) ~= type(0) then
            nixio.syslog("err", "vif_cfg, invalid value type for "..k..","..type(v))
        elseif string.byte(k) ~= string.byte("_") then
            debug_write("vif_cfg: Copying",k,v)
            cfgs[k] = v or ""
        end
    end

    -- WDS
    -- Update WdsXKey if respective WdsEncrypType is NONE
    for i=0,3 do
        if (cfgs["Wds"..i.."Key"] and cfgs["Wds"..i.."Key"] ~= "") and
           ((not mtkwifi.token_get(cfgs["WdsEncrypType"],i+1,nil)) or
            ("NONE" == mtkwifi.token_get(cfgs["WdsEncrypType"],i+1,nil))) then
            cfgs["Wds"..i.."Key"] = ""
        end
    end

    cfgs["AccessPolicy"..vif_idx-1] = http.formvalue("__accesspolicy")
    local t = mtkwifi.parse_mac(http.formvalue("__maclist"))
    cfgs["AccessControlList"..vif_idx-1] = table.concat(t, ";")

    __security_cfg(cfgs, vif_idx)
    __update_mbss_para(cfgs, vif_idx)
    __set_wifi_wpsconf(cfgs, http.formvalue("WPSRadio"), vif_idx)

    __mtkwifi_save_profile(cfgs, profile, false)
    if http.formvalue("__apply") then
        mtkwifi.__run_in_child_env(__mtkwifi_reload, devname)
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",to_url))
    else
        luci.http.redirect(to_url)
    end
end

function get_WPS_Info(devname, ifname)
    local devs = mtkwifi.get_all_devs()
    local ssid_index = devs[devname]["vifs"][ifname].vifidx
    local profile = devs[devname].profile
    assert(profile)

    local cfgs = mtkwifi.load_profile(profile)

    -- Create the applied settings backup file if it does not exist.
    if not mtkwifi.exists(mtkwifi.__profile_applied_settings_path(profile)) then
        os.execute("cp -f "..profile.." "..mtkwifi.__profile_applied_settings_path(profile))
    end
    local applied_cfgs = mtkwifi.load_profile(mtkwifi.__profile_applied_settings_path(profile))

    local WPS_details = {}
    WPS_details = c_getCurrentWscProfile(ifname)

    if type(WPS_details) ~= "table" then
        WPS_details["DRIVER_RSP"] = "NO"
    else
        WPS_details["DRIVER_RSP"] = "YES"
        local isCfgsChanged = false  -- To indicate that the settings have been changed by External Registrar.
        local isBasicTabUpdateRequired = false

        if type(WPS_details["SSID"]) == "string" then
            if applied_cfgs["SSID"..ssid_index] ~= WPS_details["SSID"] then
                cfgs["SSID"..ssid_index] = WPS_details["SSID"]
                isCfgsChanged = true
                isBasicTabUpdateRequired = true
            end
        else
            WPS_details["SSID"] = cfgs["SSID"..ssid_index]
        end

        if type(WPS_details["AuthMode"]) == "string" then
            local auth_mode_ioctl = WPS_details["AuthMode"]:gsub("%W",""):upper()
            local auth_mode_applied = mtkwifi.token_get(applied_cfgs.AuthMode, ssid_index, "")
            if auth_mode_applied ~= auth_mode_ioctl then
                cfgs.AuthMode = mtkwifi.token_set(cfgs.AuthMode, ssid_index, auth_mode_ioctl)
                isCfgsChanged = true
                isBasicTabUpdateRequired = true
            end
        else
            WPS_details["AuthMode"] = mtkwifi.token_get(cfgs.AuthMode, ssid_index, "")
        end

        if type(WPS_details["EncType"]) == "string" then
            local enc_type_ioctl = WPS_details["EncType"]:upper()
            local enc_type_applied = mtkwifi.token_get(applied_cfgs.EncrypType, ssid_index, "")
            if enc_type_applied ~= enc_type_ioctl then
                cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, ssid_index, enc_type_ioctl)
                isCfgsChanged = true
                isBasicTabUpdateRequired = true
            end
        else
            WPS_details["EncType"] = mtkwifi.token_get(cfgs.EncrypType, ssid_index, "")
        end

        if type(WPS_details["WscWPAKey"]) == "string" then
            if applied_cfgs["WPAPSK"..ssid_index] ~= WPS_details["WscWPAKey"] then
                cfgs["WPAPSK"..ssid_index] = WPS_details["WscWPAKey"]
                isCfgsChanged = true
                isBasicTabUpdateRequired = true
            end
        else
            WPS_details["WscWPAKey"] = cfgs["WPAPSK"..ssid_index]
        end

        if type(WPS_details["DefKey"]) == "number" then
            local def_key_applied = tonumber(mtkwifi.token_get(applied_cfgs.DefaultKeyID, ssid_index, ""))
            if def_key_applied ~= WPS_details["DefKey"] then
                cfgs.DefaultKeyID = mtkwifi.token_set(cfgs.DefaultKeyID, ssid_index, WPS_details["DefKey"])
                isCfgsChanged = true
            end
        else
            WPS_details["DefKey"] = tonumber(mtkwifi.token_get(cfgs.DefaultKeyID, ssid_index, 0)) or ""
        end

        if type(WPS_details["Conf"]) == "number" then
            local wsc_conf_status_applied = tonumber(mtkwifi.token_get(applied_cfgs.WscConfStatus, ssid_index, ""))
            if wsc_conf_status_applied ~= WPS_details["Conf"] then
                cfgs.WscConfStatus = mtkwifi.token_set(cfgs.WscConfStatus, ssid_index, WPS_details["Conf"])
                isCfgsChanged = true
            end
        else
            WPS_details["Conf"] = mtkwifi.token_get(cfgs.WscConfStatus, ssid_index, "")
        end

        WPS_details["IS_BASIC_TAB_UPDATE_REQUIRED"] = isBasicTabUpdateRequired

        if isCfgsChanged then
            -- Driver updates the *.dat file for following scenarios,
            --     1. When WPS Conf Status is not configured i.e. WscConfStatus is not set as 2,
            --        and connection with a station is established i.e. where station acts as an External Registrar.
            --     2. When below settings are changed through External Registrar irrespective of WPS Conf Status
            -- Update mtkwifi.__profile_applied_settings_path(profile) file with the
            -- new settings to avoid display of "reload to apply changes" message.
            applied_cfgs["WPAPSK"] = cfgs["WPAPSK"]
            applied_cfgs["SSID"] = cfgs["SSID"]
            applied_cfgs["SSID"..ssid_index] = cfgs["SSID"..ssid_index]
            applied_cfgs["AuthMode"] = cfgs["AuthMode"]
            applied_cfgs["EncrypType"] = cfgs["EncrypType"]
            applied_cfgs["WPAPSK"..ssid_index] = cfgs["WPAPSK"..ssid_index]
            applied_cfgs["DefaultKeyID"] = cfgs["DefaultKeyID"]
            applied_cfgs["WscConfStatus"] = cfgs["WscConfStatus"]
            mtkwifi.save_profile(applied_cfgs, mtkwifi.__profile_applied_settings_path(profile))
        end
    end
    http.write_json(WPS_details)
end

function get_wifi_pin(ifname)
    local pin = ""
    pin = c_getApPin(ifname)
    http.write_json(pin)
end

function set_wifi_gen_pin(ifname,devname)
    local devs = mtkwifi.get_all_devs()
    local ssid_index = devs[devname]["vifs"][ifname].vifidx
    local profile = devs[devname].profile
    assert(profile)

    local cfgs = mtkwifi.load_profile(profile)

    os.execute("iwpriv "..ifname.." set WscGenPinCode")

    pin = c_getApPin(ifname)
    cfgs["WscVendorPinCode"]=pin["genpincode"]

    --existing c code... done nothing for this segment as it read flash data and write to related .dat file.
    -- no concept of nvram zones here
    --if (nvram == RT2860_NVRAM)
    --    do_system("ralink_init make_wireless_config rt2860");
    --else
    --    do_system("ralink_init make_wireless_config rtdev");
    __mtkwifi_save_profile(cfgs, profile, true)
    http.write_json(pin)
end

function set_wifi_wps_oob(devname, ifname)
    local SSID, mac = ""
    local  ssid_index = 0
    local devs = mtkwifi.get_all_devs()
    local profile = devs[devname].profile
    assert(profile)

    local cfgs = mtkwifi.load_profile(profile)

    ssid_index = devs[devname]["vifs"][ifname].vifidx
    mac = c_get_macaddr(ifname)

    if (mac["macaddr"]  ~= "") then
        SSID = "RalinkInitAP"..(ssid_index-1).."_"..mac["macaddr"]
    else
        SSID = "RalinkInitAP"..(ssid_index-1).."_unknown"
    end

    cfgs["SSID"..ssid_index]=SSID
    cfgs.WscConfStatus = mtkwifi.token_set(cfgs.WscConfStatus, ssid_index, "1")
    cfgs.AuthMode = mtkwifi.token_set(cfgs.AuthMode, ssid_index, "WPA2PSK")
    cfgs.EncrypType = mtkwifi.token_set(cfgs.EncrypType, ssid_index, "AES")
    cfgs.DefaultKeyID = mtkwifi.token_set(cfgs.DefaultKeyID, ssid_index, "2")

    cfgs["WPAPSK"..ssid_index]="12345678"
    cfgs["WPAPSK"]=""
    cfgs.IEEE8021X = mtkwifi.token_set(cfgs.IEEE8021X, ssid_index, "0")

    os.execute("iwpriv "..ifname.." set SSID="..SSID )
    debug_write("iwpriv "..ifname.." set SSID="..SSID )
    os.execute("iwpriv "..ifname.." set AuthMode=WPA2PSK")
    debug_write("iwpriv "..ifname.." set AuthMode=WPA2PSK")
    os.execute("iwpriv "..ifname.." set EncrypType=AES")
    debug_write("iwpriv "..ifname.." set EncrypType=AES")
    os.execute("iwpriv "..ifname.." set WPAPSK=12345678")
    debug_write("iwpriv "..ifname.." set WPAPSK=12345678")
    os.execute("iwpriv "..ifname.." set SSID="..SSID)
    debug_write("iwpriv "..ifname.." set SSID="..SSID)

    cfgs = mtkwifi.__restart_if_wps(devname, ifname, cfgs)
    __mtkwifi_save_profile(cfgs, profile, true)

    mtkwifi.__run_in_child_env(__restart_all_daemons, devname, ifname)

    os.execute("iwpriv "..ifname.." set WscConfStatus=1")
    debug_write("iwpriv "..ifname.." set WscConfStatus=1")

    local url_to_visit_after_reload = luci.dispatcher.build_url("admin", "mtk", "wifi", "vif_cfg_view", devname, ifname)
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",url_to_visit_after_reload))
end

function set_wifi_do_wps(ifname, devname, wsc_pin_code_w)
    local devs = mtkwifi.get_all_devs()
    local ssid_index = devs[devname]["vifs"][ifname].vifidx
    local profile = devs[devname].profile
    local wsc_mode = 0
    local wsc_conf_mode
    assert(profile)

    local cfgs = mtkwifi.load_profile(profile)

    if(wsc_pin_code_w == "nopin") then
        wsc_mode=2
    else
        wsc_mode=1
    end

    wsc_conf_mode = mtkwifi.token_get(cfgs["WscConfMode"], ssid_index, nil)

    if (wsc_conf_mode == 0) then
        print("{\"wps_start\":\"WPS_NOT_ENABLED\"}")
        DBG_MSG("WPS is not enabled before do PBC/PIN.\n")
        return
    end

    if (wsc_mode == 1) then
        __wps_ap_pin_start_all(ifname, wsc_pin_code_w)

    elseif (wsc_mode == 2) then
        __wps_ap_pbc_start_all(ifname)
    else
        http.write_json("{\"wps_start\":\"NG\"}")
        return
    end
    cfgs["WscStartIF"] = ifname

    -- execute wps_action.lua file to send signal for current interface
    os.execute("lua wps_action.lua "..ifname)

    http.write_json("{\"wps_start\":\"OK\"}")
end

function get_wps_security(ifname, devname)
    local devs = mtkwifi.get_all_devs()
    local ssid_index = devs[devname]["vifs"][ifname].vifidx
    local profile = devs[devname].profile
    assert(profile)
    local output = {}
    local cfgs = mtkwifi.load_profile(profile)

    output["AuthMode"] = mtkwifi.token_get(cfgs.AuthMode,ssid_index)
    output["IEEE8021X"] = mtkwifi.token_get(cfgs.IEEE8021X,ssid_index)

    http.write_json(output)
end

function apcli_get_wps_status(ifname, devname)
    local output = {}
    local  ssid_index = 0
    local devs = mtkwifi.get_all_devs()
    local profile = devs[devname].profile
    assert(profile)

    -- apcli interface has a different structure as compared to other vifs
    ssid_index = devs[devname][ifname].vifidx
    output = c_apcli_get_wps_status(ifname)
    if (output.wps_port_secured == "YES") then
        local cfgs = mtkwifi.load_profile(profile)
        cfgs.ApCliSsid = mtkwifi.token_set(cfgs.ApCliSsid, ssid_index, output.enr_SSID)
        cfgs.ApCliEnable = mtkwifi.token_set(cfgs.ApCliEnable, ssid_index, "1")
        cfgs.ApCliAuthMode = mtkwifi.token_set(cfgs.ApCliAuthMode, ssid_index, output.enr_AuthMode)
        cfgs.ApCliEncrypType = mtkwifi.token_set(cfgs.ApCliEncrypType, ssid_index, output.enr_EncrypType)
        cfgs.ApCliDefaultKeyID = mtkwifi.token_set(cfgs.ApCliDefaultKeyID, ssid_index, output.enr_DefaultKeyID)
        cfgs.Channel = mtkwifi.read_pipe("iwconfig "..ifname.." | grep Channel | cut -d = -f 2 | cut -d \" \" -f 1")
        debug_write("iwconfig "..ifname.." | grep Channel | cut -d = -f 2 | cut -d \" \" -f 1")

        if(output.enr_EncrypType == "WEP") then
            for i = 1, 4 do
                cfgs["ApCliKey"..i.."Type"] = mtkwifi.token_set(cfgs["ApCliKey"..i.."Type"], ssid_index, output["Key"..i.."Type"])
            end
            if(ssid_index == "0") then
                cfgs["ApCliKey"..output.enr_DefaultKeyID.."Str"] = output.enr_KeyStr
            else
                cfgs["ApCliKey"..output.enr_DefaultKeyID.."Str"..ssid_index] = output.enr_KeyStr
            end
        elseif(output.enr_EncrypType == "TKIP") or (output.enr_EncrypType == "AES") or (output.enr_EncrypType == "TKIPAES") then
            if(output.enr_AuthMode ~= "WPAPSKWPA2PSK") then
                cfgs["ApCliWPAPSK"] = output.enr_WPAPSK
            end
        end
        __mtkwifi_save_profile(cfgs, profile, true)
    end
    http.write_json(output);
end

function string.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

function unencode_ssid(raw_ssid)
    local c
    local output = ""
    local convertNext = 0
    for c in raw_ssid:gmatch"." do
        if(convertNext == 0) then
            if(c == '+') then
                output = output..' '
            elseif(c == '%') then
                convertNext = 1
            else
                output = output..c
            end
        else
            output = output..string.tohex(c)
            convertNext = 0
        end
    end
    return output
end

function decode_ssid(raw_ssid)
    local output = raw_ssid
    output = output:gsub("&amp;", "&")
    output = output:gsub("&lt;", "<")
    output = output:gsub("&gt;", ">")
    output = output:gsub("&#34;", "\"")
    output = output:gsub("&#39;", "'")
    output = output:gsub("&nbsp;", " ")
    for codenum in raw_ssid:gmatch("&#(%d+);") do
        output = output:gsub("&#"..codenum..";", string.char(tonumber(codenum)))
    end
    return output
end

function apcli_do_enr_pin_wps(ifname, devname, raw_ssid)
    local target_ap_ssid = ""
    local ret_value = {}
    if(raw_ssid == "") then
        ret_value["apcli_do_enr_pin_wps"] = "GET_SSID_NG"
    end
    ret_value["raw_ssid"] = raw_ssid
    target_ap_ssid = decode_ssid(raw_ssid)
    target_ap_ssid = ''..mtkwifi.__handleSpecialChars(target_ap_ssid)
    ret_value["target_ap_ssid"] = target_ap_ssid
    if(target_ap_ssid == "") then
        ret_value["apcli_do_enr_pin_wps"] = "GET_SSID_NG"
    else
        ret_value["apcli_do_enr_pin_wps"] = "OK"
    end
    os.execute("ifconfig "..ifname.." up")
    debug_write("ifconfig "..ifname.." up")
    os.execute("brctl addif br0 "..ifname)
    debug_write("brctl addif br0 "..ifname)
    os.execute("brctl addif br-lan "..ifname)
    debug_write("brctl addif br-lan "..ifname)
    os.execute("iwpriv "..ifname.." set ApCliAutoConnect=1")
    os.execute("iwpriv "..ifname.." set ApCliEnable=1")
    debug_write("iwpriv "..ifname.." set ApCliEnable=1")
    --os.execute("iwpriv "..ifname.." set WscConfMode=0")
    os.execute("iwpriv "..ifname.." set WscConfMode=1")
    debug_write("iwpriv "..ifname.." set WscConfMode=1")
    os.execute("iwpriv "..ifname.." set WscMode=1")
    debug_write("iwpriv "..ifname.." set WscMode=1")
    os.execute("iwpriv "..ifname.." set ApCliWscSsid=\""..target_ap_ssid.."\"")
    debug_write("iwpriv "..ifname.." set ApCliWscSsid=\""..target_ap_ssid.."\"")
    os.execute("iwpriv "..ifname.." set WscGetConf=1")
    debug_write("iwpriv "..ifname.." set WscGetConf=1")
    -- check interface value to correlate with nvram as values will be like apclixxx
    os.execute("wps_action.lua "..ifname)
    http.write_json(ret_value)
end

function apcli_do_enr_pbc_wps(ifname, devname)
    local ret_value = {}

    --os.execute("iwpriv "..ifname.." set ApCliAutoConnect=1")
    --os.execute("iwpriv "..ifname.." set ApCliEnable=1")
    --os.execute("ifconfig "..ifname.." up")
    --os.execute("brctl addif br0 "..ifname)
    --os.execute("iwpriv "..ifname.." set WscConfMode=0")
    os.execute("iwpriv "..ifname.." set WscConfMode=1")
    os.execute("iwpriv "..ifname.." set WscMode=2")
    os.execute("iwpriv "..ifname.." set WscGetConf=1")
    -- check interface value to correlate with nvram as values will be like apclixxx
    os.execute("wps_action.lua "..ifname)

    --debug_write("iwpriv "..ifname.." set ApCliEnable=1")
    --debug_write("brctl addif br0 "..ifname)
    --debug_write("ifconfig "..ifname.." up")
    debug_write("iwpriv "..ifname.." set WscConfMode=1")
    debug_write("iwpriv "..ifname.." set WscMode=2")
    debug_write("iwpriv "..ifname.." set WscGetConf=1")
    ret_value["apcli_do_enr_pbc_wps"] = "OK"
    http.write_json(ret_value)
end

function apcli_cancel_wps(ifname)
    local ret_value = {}
    os.execute("iwpriv "..ifname.." set WscStop=1")
    os.execute("miniupnpd.sh init")
    -- check interface value to correlate with nvram as values will be like apclixxx
    os.execute("wps_action.lua "..ifname)
    ret_value["apcli_cancel_wps"] = "OK"
    http.write_json(ret_value)
end

function apcli_wps_gen_pincode(ifname)
    local ret_value = {}
    os.execute("iwpriv "..ifname.." set WscGenPinCode")
    ret_value["apcli_wps_gen_pincode"] = "OK"
    http.write_json(ret_value)
end

function apcli_wps_get_pincode(ifname)
    local output = c_apcli_wps_get_pincode(ifname)
    http.write_json(output)
end

function get_apcli_conn_info(ifname)
    local rsp = {}
    if not ifname then
        rsp["conn_state"]="Disconnected"
    else
        local flags = tonumber(mtkwifi.read_pipe("cat /sys/class/net/"..ifname.."/flags 2>/dev/null")) or 0
        rsp["infc_state"] = flags%2 == 1 and "up" or "down"
        local iwapcli = mtkwifi.read_pipe("iwconfig "..ifname.." | grep ESSID 2>/dev/null")
        local ssid = string.match(iwapcli, "ESSID:\"(.*)\"")
        iwapcli = mtkwifi.read_pipe("iwconfig "..ifname.." | grep 'Access Point' 2>/dev/null")
        local bssid = string.match(iwapcli, "%x%x:%x%x:%x%x:%x%x:%x%x:%x%x")
        if not ssid or ssid == "" then
            rsp["conn_state"]= "Disconnected"
        else
            rsp["conn_state"] = "Connected"
            rsp["ssid"] = ssid
            rsp["bssid"] = bssid or "N/A"
        end
    end
    http.write_json(rsp)
end

function sta_info(ifname)
    local output = {}
    local stalist = c_StaInfo(ifname)

    local count = 0
    for _ in pairs(stalist) do count = count + 1 end

    for i=0, count - 1 do
        table.insert(output, stalist[i])
    end
    http.write_json(output)
end

function apcli_scan(ifname)
    local aplist = mtkwifi.scan_ap(ifname)
    local convert="";
    for i=1, #aplist do
        convert = c_convert_string_display(aplist[i]["ssid"])
        aplist[i]["original_ssid"] = aplist[i]["ssid"]
        aplist[i]["ssid"] = convert["output"]
    end
    http.write_json(aplist)
end

function get_station_list()
    http.write("get_station_list")
end

function reset_wifi(devname)
    if devname then
        os.execute("cp -f /rom/etc/wireless/"..devname.."/ /etc/wireless/")
    else
        os.execute("cp -rf /rom/etc/wireless /etc/")
    end
    return luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi"))
end

function reload_wifi(devname)
    profiles = mtkwifi.search_dev_and_profile()
    path = profiles[devname]
    mtkwifi.__run_in_child_env(__mtkwifi_reload, devname)
    local url_to_visit_after_reload = luci.dispatcher.build_url("admin", "mtk", "wifi")
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",url_to_visit_after_reload))
end

function get_raw_profile()
    local sid = http.formvalue("sid")
    http.write_json("get_raw_profile")
end

function get_country_region_list()
    local mode = http.formvalue("mode")
    local cr_list;

    if mtkwifi.band(mode) == "5G" then
        cr_list = mtkwifi.CountryRegionList_5G_All
    elseif mtkwifi.band(mode) == "6G" then
        cr_list = mtkwifi.CountryRegionList_6G_All
    else
        cr_list = mtkwifi.CountryRegionList_2G_All
    end

    http.write_json(cr_list)
end

function remove_ch_by_region(ch_list, region)
    for i = #ch_list,2,-1 do
        if not ch_list[i].region[region] then
            table.remove(ch_list, i)
        end
    end
end

function get_channel_list()
    local mode = http.formvalue("mode")
    local region = tonumber(http.formvalue("country_region")) or 1
    local ch_list

    if mtkwifi.band(mode) == "5G" then
        ch_list = mtkwifi.ChannelList_5G_All
    elseif mtkwifi.band(mode) == "6G" then
        ch_list = mtkwifi.ChannelList_6G_All
    else
        ch_list = mtkwifi.ChannelList_2G_All
    end

    remove_ch_by_region(ch_list, region)
    http.write_json(ch_list)
end

function get_HT_ext_channel_list()
    local mode = http.formvalue("mode")
    local ch_cur = tonumber(http.formvalue("ch_cur"))
    local region = tonumber(http.formvalue("country_region")) or 1
    local ext_ch_list = {}

    if mtkwifi.band(mode) == "6G" then -- 6G Channel
        local ch_list = mtkwifi.ChannelList_6G_All
        local ext_ch_idx = -1
        local len = 0

        for k, v in ipairs(ch_list) do
            len = len + 1
            if v.channel == ch_cur then
                ext_ch_idx = (k % 2 == 0) and k + 1 or k - 1
            end
        end

        if ext_ch_idx > 0 and ext_ch_idx < len and ch_list[ext_ch_idx].region[region] then
            ext_ch_list[1] = {}
            ext_ch_list[1].val = ext_ch_idx % 2
            ext_ch_list[1].text = ch_list[ext_ch_idx].text
        end
        
    elseif mtkwifi.band(mode) == "2.4G" then -- 2.4G Channel
        local ch_list = mtkwifi.ChannelList_2G_All
        local below_ch = ch_cur - 4
        local above_ch = ch_cur + 4
        local i = 1

        if below_ch > 0 and ch_list[below_ch + 1].region[region] then
            ext_ch_list[i] = {}
            ext_ch_list[i].val = 0
            ext_ch_list[i].text = ch_list[below_ch + 1].text
            i = i + 1
        end

        if above_ch <= 14 and ch_list[above_ch + 1].region[region] then
            ext_ch_list[i] = {}
            ext_ch_list[i].val = 1
            ext_ch_list[i].text = ch_list[above_ch + 1].text
        end
    else  -- 5G Channel
        local ch_list = mtkwifi.ChannelList_5G_All
        local ext_ch_idx = -1
        local len = 0

        for k, v in ipairs(ch_list) do
            len = len + 1
            if v.channel == ch_cur then
                ext_ch_idx = (k % 2 == 0) and k + 1 or k - 1
            end
        end

        if ext_ch_idx > 0 and ext_ch_idx < len and ch_list[ext_ch_idx].region[region] then
            ext_ch_list[1] = {}
            ext_ch_list[1].val = ext_ch_idx % 2
            ext_ch_list[1].text = ch_list[ext_ch_idx].text
        end
    end

    http.write_json(ext_ch_list)
end

function get_5G_2nd_80Mhz_channel_list()
    local ch_cur = tonumber(http.formvalue("ch_cur"))
    local region = tonumber(http.formvalue("country_region"))
    local ch_list = mtkwifi.ChannelList_5G_2nd_80MHZ_ALL
    local ch_list_5g = mtkwifi.ChannelList_5G_All
    local i, j, test_ch, test_idx
    local bw80_1st_idx = -1

    -- remove adjacent freqencies starting from list tail.
    for i = #ch_list,1,-1 do
        for j = 0,3 do
            if ch_list[i].channel == -1 then
                break
            end

            test_ch = ch_list[i].channel + j * 4
            test_idx = ch_list[i].chidx + j

            if test_ch == ch_cur then
            if i + 1 <= #ch_list and ch_list[i + 1] then
                table.remove(ch_list, i + 1)
            end
            table.remove(ch_list, i)
                bw80_1st_idx = i
                break
            end

            if i == (bw80_1st_idx - 1) or (not ch_list_5g[test_idx].region[region]) then
                table.remove(ch_list, i)
            break
        end
    end
    end

    -- remove unused channel.
    for i = #ch_list,1,-1 do
        if ch_list[i].channel == -1 then
            table.remove(ch_list, i)
        end
    end
    http.write_json(ch_list)
end

function webcmd()
    local cmd = http.formvalue("cmd")
    if cmd then
        local result = mtkwifi.read_pipe(tostring(cmd).." 2>&1")
        result = result:gsub("<", "&lt;")
        http.write(tostring(result))
    else
        http.write_json(http.formvalue())
    end
end

function net_cfg()
    http.write_json(http.formvalue())
end

function apcli_cfg(dev, vif)
    local devname = dev
    debug_write(devname)
    local profiles = mtkwifi.search_dev_and_profile()
    debug_write(profiles[devname])
    assert(profiles[devname])

    local cfgs = mtkwifi.load_profile(profiles[devname])

    for k,v in pairs(http.formvalue()) do
        if type(v) ~= type("") and type(v) ~= type(0) then
            nixio.syslog("err", "apcli_cfg, invalid value type for "..k..","..type(v))
        elseif string.byte(k) ~= string.byte("_") then
            cfgs[k] = v or ""
        end
    end

    if cfgs['ApCliEnable'] == '1' then
        os.execute("brctl addif br-lan "..vif)
    end

    -- http.write_json(http.formvalue())

    -- Mediatek Adaptive Network
    --[=[ moved to a separated page
    if cfgs.ApCliEzEnable then
        cfgs.EzEnable = cfgs.ApCliEzEnable
        cfgs.ApMWDS = cfgs.ApCliMWDS
        cfgs.EzConfStatus = cfgs.ApCliEzConfStatus
        cfgs.EzOpenGroupID = cfgs.ApCliEzOpenGroupID
        if http.formvalue("__group_id_mode") == "0" then
            cfgs.EzGroupID = cfgs.ApCliEzGroupID
            cfgs.EzGenGroupID = ""
            cfgs.ApCliEzGenGroupID = ""
        else
            cfgs.EzGroupID = ""
            cfgs.ApCliEzGroupID = ""
            cfgs.EzGenGroupID = cfgs.ApCliEzGenGroupID
        end
        -- if dbdc
        -- os.execute("app_ez &")
        -- os.execute("ManDaemon ")
    end
    ]=]
    __mtkwifi_save_profile(cfgs, profiles[devname], false)

    -- M.A.N Push parameters
    -- They are not part of wifi profile, we save it into /etc/man.conf.

    --[=[ moved to a separated page
    local man_ssid = http.formvalue("__man_ssid_"..vifname)
    local man_pass = http.formvalue("__man_pass_"..vifname)
    local man_auth = http.formvalue("__man_auth_"..vifname) or ""

    if man_ssid and man_pass then
        local fp = io.open("/etc/man."..vifname..".conf", "w+")
        fp:write("__man_ssid_"..vifname.."="..man_ssid.."\n")
        fp:write("__man_pass_"..vifname.."="..man_pass.."\n")
        fp:write("__man_auth_"..vifname.."="..man_auth.."\n")
        fp:close()
    end
    ]=]

    -- commented, do not connect by default
    --[=[
    os.execute("iwpriv apcli0 set ApCliEnable=0")
    os.execute("iwpriv apcli0 set Channel="..cfgs.Channel)
    os.execute("iwpriv apcli0 set ApCliAuthMode="..cfgs.ApCliAuthMode)
    os.execute("iwpriv apcli0 set ApCliEncrypType="..cfgs.ApCliEncrypType)
    if cfgs.ApCliAuthMode == "WEP" then
        os.execute("#iwpriv apcli0 set ApCliDefaultKeyID="..cfgs.ApCliDefaultKeyID)
        os.execute("#iwpriv apcli0 set ApCliKey1="..cfgs.ApCliKey1Str)
    elseif cfgs.ApCliAuthMode == "WPAPSK"
        or cfgs.ApCliAuthMode == "WPA2PSK"
        or cfgs.ApCliAuthMode == "WPAPSKWPA2PSK" then
        os.execute("iwpriv apcli0 set ApCliWPAPSK="..cfgs.ApCliWPAPSK)
    end
    -- os.execute("iwpriv apcli0 set ApCliWirelessMode=")
    os.execute("iwpriv apcli0 set ApCliSsid="..cfgs.ApCliSsid)
    os.execute("iwpriv apcli0 set ApCliEnable=1")
    ]=]
    if http.formvalue("__apply") then
        mtkwifi.__run_in_child_env(__mtkwifi_reload, devname)
        local url_to_visit_after_reload = luci.dispatcher.build_url("admin", "mtk", "wifi", "apcli_cfg_view", dev, vif)
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",url_to_visit_after_reload))
    else
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "apcli_cfg_view", dev, vif))
    end
end

function apcli_connect(dev, vif)
    -- dev_vif can be
    --  1. mt7620.apcli0         # simple case
    --  2. mt7615e.1.apclix0     # multi-card
    --  3. mt7615e.1.2G.apclix0  # multi-card & multi-profile
    local devname,vifname = dev, vif
    debug_write("devname=", dev, "vifname=", vif)
    local profiles = mtkwifi.search_dev_and_profile()
    debug_write(profiles[devname])
    assert(profiles[devname])
    local cfgs = mtkwifi.load_profile(profiles[devname])
    cfgs.ApCliEnable = "1"
    __mtkwifi_save_profile(cfgs, profiles[devname], true)
    os.execute("ifconfig "..vifname.." up")
    os.execute("brctl addif br-lan "..vifname)
    os.execute("iwpriv "..vifname.." set MACRepeaterEn="..cfgs.MACRepeaterEn)
    os.execute("iwpriv "..vifname.." set ApCliEnable=0")
    os.execute("iwpriv "..vifname.." set Channel="..cfgs.Channel)
    os.execute("iwpriv "..vifname.." set ApCliAuthMode="..cfgs.ApCliAuthMode)
    os.execute("iwpriv "..vifname.." set ApCliEncrypType="..cfgs.ApCliEncrypType)
    if cfgs.ApCliEncrypType == "WEP" then
        os.execute("iwpriv "..vifname.." set ApCliDefaultKeyID="..cfgs.ApCliDefaultKeyID)
        if (cfgs.ApCliDefaultKeyID == "1") then
            os.execute("iwpriv "..vifname.." set ApCliKey1=\""..mtkwifi.__handleSpecialChars(cfgs.ApCliKey1Str).."\"")
        elseif (cfgs.ApCliDefaultKeyID == "2") then
            os.execute("iwpriv "..vifname.." set ApCliKey2=\""..mtkwifi.__handleSpecialChars(cfgs.ApCliKey2Str).."\"")
        elseif (cfgs.ApCliDefaultKeyID == "3") then
            os.execute("iwpriv "..vifname.." set ApCliKey3=\""..mtkwifi.__handleSpecialChars(cfgs.ApCliKey3Str).."\"")
        elseif (cfgs.ApCliDefaultKeyID == "4") then
            os.execute("iwpriv "..vifname.." set ApCliKey4=\""..mtkwifi.__handleSpecialChars(cfgs.ApCliKey4Str).."\"")
        end
    elseif cfgs.ApCliAuthMode == "WPAPSK"
        or cfgs.ApCliAuthMode == "WPA2PSK"
        or cfgs.ApCliAuthMode == "WPAPSKWPA2PSK" then
        os.execute("iwpriv "..vifname.." set ApCliWPAPSK=\""..mtkwifi.__handleSpecialChars(cfgs.ApCliWPAPSK).."\"")
    end
    os.execute("iwpriv "..vifname.." set ApCliSsid=\""..mtkwifi.__handleSpecialChars(cfgs.ApCliSsid).."\"")
    os.execute("iwpriv "..vifname.." set ApCliEnable=1")
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi"))
end

function apcli_disconnect(dev, vif)
    -- dev_vif can be
    --  1. mt7620.apcli0         # simple case
    --  2. mt7615e.1.apclix0     # multi-card
    --  3. mt7615e.1.2G.apclix0  # multi-card & multi-profile
    local devname,vifname = dev, vif
    debug_write("devname=", dev, "vifname", vif)
    debug_write(devname)
    debug_write(vifname)
    local profiles = mtkwifi.search_dev_and_profile()
    debug_write(profiles[devname])
    assert(profiles[devname])
    local cfgs = mtkwifi.load_profile(profiles[devname])
    cfgs.ApCliEnable = "1"
    __mtkwifi_save_profile(cfgs, profiles[devname], true)
    os.execute("iwpriv "..vifname.." set ApCliEnable=0")
    os.execute("ifconfig "..vifname.." down")
    os.execute("brctl delif br-lan "..vifname)
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi"))
end

-- Mediatek Adaptive Network
function man_cfg()
    local mtkwifi = require("mtkwifi")
    local profiles = mtkwifi.search_dev_and_profile()

    for k,v in pairs(http.formvalue()) do
        debug_write(k.."="..v)
    end


    for dev,profile in pairs(profiles) do
        debug_write(dev.."=2======="..profile)
        local cfgs = mtkwifi.load_profile(profile)

        if cfgs.ApCliEzEnable then

            for k,v in pairs(http.formvalue()) do
                if type(v) ~= type("") and type(v) ~= type(0) then
                    nixio.syslog("err", "man_cfg, invalid value type for "..k..","..type(v))
                elseif string.byte(k) ~= string.byte("_") then
                    cfgs[k] = v or ""
                end
            end

            debug_write(tostring(http.formvalue("__"..dev.."_ezsetup")))
            cfgs.ApCliEzEnable = http.formvalue("__"..dev.."_ezsetup") or "0"

            -- Yes this is bad. LSDK insists on this.
            if cfgs.ApCliEzEnable == "1" then
                cfgs.ApCliEnable = "1"
                cfgs.ApCliMWDS = "1"
                cfgs.ApCliAuthMode = "WPS2PSK"
                cfgs.ApCliEncrypType = AES
                cfgs.ApCliWPAPSK = "12345678"
                cfgs.AuthMode = "WPA2PSK"
                cfgs.EncrypType = "AES"
                cfgs.RekeyMethod = "TIME"
                cfgs.WPAPSK1 = ""
                cfgs.RegroupSupport = "1;1"
            end

            if http.formvalue("__group_id_mode") == "0" then
                cfgs.EzGroupID = cfgs.ApCliEzGroupID
                cfgs.EzGenGroupID = ""
                cfgs.ApCliEzGenGroupID = ""
            else
                cfgs.EzGroupID = ""
                cfgs.ApCliEzGroupID = ""
                cfgs.EzGenGroupID = cfgs.ApCliEzGenGroupID
            end

            cfgs.EzEnable = cfgs.ApCliEzEnable
            cfgs.ApMWDS = cfgs.ApCliMWDS
            cfgs.EzConfStatus = cfgs.ApCliEzConfStatus
            cfgs.EzOpenGroupID = cfgs.ApCliEzOpenGroupID
        end
        __mtkwifi_save_profile(cfgs, profile, false)
    end

    if http.formvalue("__apply") then
        mtkwifi.__run_in_child_env(__mtkwifi_reload)
        local url_to_visit_after_reload = luci.dispatcher.build_url("admin", "mtk", "man")
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",url_to_visit_after_reload))
    else
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "man"))
    end
end

function apply_power_boost_settings()
    local devname = http.formvalue("__devname")
    local ret_status = {}
    local devs = mtkwifi.get_all_devs()
    local dev = {}
    for _,v in ipairs(devs) do
        if v.devname == devname then
            dev = v
            break
        end
    end
    if next(dev) == nil then
        ret_status["status"]= "Device "..(devname or "").." not found!"
    elseif not dev.isPowerBoostSupported then
        ret_status["status"]= "Power Boost feature is not supported by "..(devname or "").." Device!"
    else
        local cfgs = mtkwifi.load_profile(dev.profile)
        if type(cfgs) ~= "table" or next(cfgs) == nil then
            ret_status["status"]= "Profile settings file not found!"
        else
            for k,v in pairs(http.formvalue()) do
                if type(v) ~= type("") and type(v) ~= type(0) then
                    debug_write("ERROR: [apply_power_boost_settings] String expected; Got"..type(v).."for"..k.."key")
                    ret_status["status"]= "Power Boost settings are of incorrect type!"
                    break
                elseif string.byte(k) ~= string.byte("_") then
                    cfgs[k] = v or ""
                end
            end
            if next(ret_status) == nil then
                if type(dev.vifs) ~= "table" or next(dev.vifs) == nil or not cfgs.BssidNum or cfgs.BssidNum == "0" then
                    ret_status["status"]= "No Wireless Interfaces has been added yet!"
                elseif cfgs.PowerUpenable ~= "1" then
                    ret_status["status"]= "Power Boost feature is not enabled!"
                else
                    local up_vif_name_list = {}
                    for idx,vif in ipairs(dev.vifs) do
                        if vif.state == "up" and vif.vifname ~= nil and vif.vifname ~= "" and type(vif.vifname) == "string" then
                            up_vif_name_list[idx] = vif.vifname
                        end
                    end
                    if next(up_vif_name_list) == nil then
                        ret_status["status"]= "No Wireless Interfaces is up!"
                    else
                        for _,vifname in ipairs(up_vif_name_list) do
                            os.execute("iwpriv "..vifname.." set TxPowerBoostCtrl=0:"..cfgs.PowerUpCckOfdm)
                            os.execute("iwpriv "..vifname.." set TxPowerBoostCtrl=1:"..cfgs.PowerUpHT20)
                            os.execute("iwpriv "..vifname.." set TxPowerBoostCtrl=2:"..cfgs.PowerUpHT40)
                            os.execute("iwpriv "..vifname.." set TxPowerBoostCtrl=3:"..cfgs.PowerUpVHT20)
                            os.execute("iwpriv "..vifname.." set TxPowerBoostCtrl=4:"..cfgs.PowerUpVHT40)
                            os.execute("iwpriv "..vifname.." set TxPowerBoostCtrl=5:"..cfgs.PowerUpVHT80)
                            os.execute("iwpriv "..vifname.." set TxPowerBoostCtrl=6:"..cfgs.PowerUpVHT160)
                            os.execute("sleep 1") -- Wait for 1 second to let driver process the above data
                        end
                        __mtkwifi_save_profile(cfgs, dev.profile, true)
                        ret_status["status"]= "SUCCESS"
                    end
                end
            end
        end
    end
    http.write_json(ret_status)
end

function get_bssid_num(devName)
    local ret_status = {}
    local profiles = mtkwifi.search_dev_and_profile()
    for dev,profile in pairs(profiles) do
        if devName == dev then
            local cfgs = mtkwifi.load_profile(profile)
            if type(cfgs) ~= "table" or next(cfgs) == nil then
                ret_status["status"]= "Profile settings file not found!"
            else
                ret_status["status"] = "SUCCESS"
                ret_status["bssidNum"] = cfgs.BssidNum
            end
            break
        end
    end
    if next(ret_status) == nil then
        ret_status["status"]= "Device "..(devName or "").." not found!"
    end
    http.write_json(ret_status)
end

local exec_reset_to_defaults_cmd = function (devname)
    if devname then
        os.execute("wifi reset "..devname)
    else
        os.execute("wifi reset")
    end
end

function reset_to_defaults(devname)
    mtkwifi.__run_in_child_env(exec_reset_to_defaults_cmd, devname)
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",mtkwifi.get_referer_url()))
end

local exec_reset_to_default_easymesh_cmd = function ()
    -- OpenWRT
    if mtkwifi.exists("/usr/bin/EasyMesh_openwrt.sh") then
        os.execute("/usr/bin/EasyMesh_openwrt.sh default")
    elseif mtkwifi.exists("/usr/bin/EasyMesh_7622.sh") then
        os.execute("/usr/bin/EasyMesh_7622.sh default")
    elseif mtkwifi.exists("/usr/bin/EasyMesh_7629.sh") then
        os.execute("/usr/bin/EasyMesh_7629.sh default")
    end
    -- LSDK
    if mtkwifi.exists("/sbin/EasyMesh.sh") then
        os.execute("EasyMesh.sh default")
    end
end

function reset_to_default_easymesh()
    mtkwifi.__run_in_child_env(exec_reset_to_default_easymesh_cmd)

    if mtkwifi.exists("/etc/dpp_cfg.txt") then
        local dpp_cfg = mtkwifi.load_profile("/etc/dpp_cfg.txt")
        dpp_cfg.allowed_role = "1"
        mtkwifi.save_profile(dpp_cfg, "/etc/dpp_cfg.txt")
    end

    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",mtkwifi.get_referer_url()))
end

function save_easymesh_driver_profile(easymesh_cfgs)
    local profiles = mtkwifi.search_dev_and_profile()
    local detected_5g = false
    -- Following EasyMesh settings must be written to all DAT files of Driver,
    --    1. MapEnable
    --    2. MAP_Turnkey
    for _,profile in mtkwifi.__spairs(profiles, function(a,b) return string.upper(a) < string.upper(b) end) do
        local driver_cfgs = mtkwifi.load_profile(profile)
        driver_cfgs['MapMode'] = easymesh_cfgs['MapMode']
        if http.formvalue("TriBand") == "1" then
            if detected_5g == false and mtkwifi.band(string.split(driver_cfgs.WirelessMode,";")[1]) == "5G" then
                driver_cfgs['ChannelGrp'] = "0:0:1:1"
                detected_5g = true
            elseif detected_5g == true and mtkwifi.band(string.split(driver_cfgs.WirelessMode,";")[1]) == "5G" then
                driver_cfgs['ChannelGrp'] = "1:1:0:0"
            end
        elseif http.formvalue("TriBand") == "2" then
            if detected_5g == false and mtkwifi.band(string.split(driver_cfgs.WirelessMode,";")[1]) == "5G" then
                driver_cfgs['ChannelGrp'] = "1:1:0:0"
                detected_5g = true
            elseif detected_5g == true and mtkwifi.band(string.split(driver_cfgs.WirelessMode,";")[1]) == "5G" then
                driver_cfgs['ChannelGrp'] = "0:0:1:1"
            end
        end
        if driver_cfgs['MapMode'] == "1" then
            driver_cfgs['SREnable'] = "0"
            driver_cfgs['SRMode'] = "0"
        end
        if easymesh_cfgs['MeshSREnable'] == "1" then
            driver_cfgs['SREnable'] = "1"
            driver_cfgs['SRMode'] = "1"
            driver_cfgs['MapBalance'] = "1"
            driver_cfgs['BSSColorValue'] = "254"
        elseif easymesh_cfgs['MeshSREnable'] == "0" then
            driver_cfgs['SREnable'] = "0"
            driver_cfgs['SRMode'] = "0"
            driver_cfgs['MapBalance'] = "0"
            driver_cfgs['BSSColorValue'] = "255"
        end
        __mtkwifi_save_profile(driver_cfgs, profile, false)
    end
end

function map_cfg()
    local easymesh_cfgs = mtkwifi.load_profile(mtkwifi.__write_easymesh_profile_path())
    assert(easymesh_cfgs)

    local easymesh_applied_path = mtkwifi.__profile_applied_settings_path(mtkwifi.__write_easymesh_profile_path())
    os.execute("cp -f "..mtkwifi.__write_easymesh_profile_path().." "..easymesh_applied_path)

    for k,v in pairs(http.formvalue()) do
        if type(v) ~= type("") and type(v) ~= type(0) then
            debug_write("map_cfg: Invalid value type for "..k..","..type(v))
        elseif string.byte(k) ~= string.byte("_") then
            debug_write("map_cfg: Copying key:"..k..","..type(v))
            easymesh_cfgs[k] = v or ""
        end
    end

    local bands = mtkwifi.detect_triband()
    if bands ~= 3 then
        easymesh_cfgs['BhPriority5GH'] = easymesh_cfgs['BhPriority5GL']
    end

    save_easymesh_driver_profile(easymesh_cfgs)
    mtkwifi.save_write_easymesh_profile(easymesh_cfgs)

    if http.formvalue("__apply") then

        if http.formvalue("__ChangeDeviceRole")=="changed" then
            os.execute("wappctrl ra0 dpp dpp_reset_dpp_config_file")
        end

        if mtkwifi.exists("/etc/dpp_cfg.txt") then
            local dpp_cfg = mtkwifi.load_profile("/etc/dpp_cfg.txt")
            if http.formvalue("DeviceRole")=="1" then
                dpp_cfg.allowed_role="2"
            elseif  http.formvalue("DeviceRole")== "2" then
                dpp_cfg.allowed_role="1"
            elseif  http.formvalue("DeviceRole")== "0" then
                dpp_cfg.allowed_role="0"
            end
            mtkwifi.save_profile(dpp_cfg, "/etc/dpp_cfg.txt")
        end

        if mtkwifi.exists("/usr/bin/map_restart.sh") then
            mtkwifi.__run_in_child_env(exec_map_restart)
        else
            mtkwifi.__run_in_child_env(__mtkwifi_reload)
        end

        local url_to_visit_after_reload = luci.dispatcher.build_url("admin", "mtk", "multi_ap")
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "wifi", "loading",url_to_visit_after_reload))
    else
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "multi_ap"))
    end
end

function exec_map_restart()
    if mtkwifi.exists("/usr/bin/map_restart.sh") then
        os.execute("/usr/bin/map_restart.sh")
    end
end

function get_device_role()
    local devRole = c_get_device_role()
    -- Set ApCliEnable as "1" for Device with on-boarded ApCli interface to let
    -- UI display connection information of ApCli interface on Wireless Overview web-page.
    if tonumber(devRole.mapDevRole) == 2 then
        local r = mtkwifi.get_easymesh_on_boarded_iface_info()
        if r['status'] == "SUCCESS" then
            for profile in string.gmatch(r['profile'],'(.-%.dat);') do
                local cfgs = mtkwifi.load_profile(profile)
                if cfgs.ApCliEnable ~= "1" or cfgs.ApCliEnable == nil then
                    cfgs.ApCliEnable = "1"
                    __mtkwifi_save_profile(cfgs, profile, true)
                end
            end
        end
    end
    http.write_json(devRole)
end

function trigger_uplink_ap_selection()
    local r = c_trigger_uplink_ap_selection()
    http.write_json(r)
end

function trigger_mandate_steering_on_agent(sta_mac, target_bssid)
    sta_mac = sta_mac:sub(1,17)
    target_bssid = target_bssid:sub(1,17)
    local r = c_trigger_mandate_steering_on_agent(sta_mac, target_bssid)
    http.write_json(r)
end

function trigger_back_haul_steering_on_agent(bh_mac, bh_target_bssid)
    bh_mac = bh_mac:sub(1,17)
    bh_target_bssid = bh_target_bssid:sub(1,17)
    local r = c_trigger_back_haul_steering_on_agent(bh_mac, bh_target_bssid)
    http.write_json(r)
end

function trigger_wps_fh_agent(fh_bss_mac)
    fh_bss_mac = fh_bss_mac:sub(1,17)
    local r = c_trigger_wps_fh_agent(fh_bss_mac)
    http.write_json(r)
end

function trigger_multi_ap_on_boarding(ifmed)
    assert(ifmed)
    onboardingType = ifmed
    debug_write("trigger_multi_ap_on_boarding: onboardingType:"..ifmed)
    local r = c_trigger_multi_ap_on_boarding(ifmed)
    http.write_json(r)
end

function get_runtime_topology()
    local r = c_get_runtime_topology()
    http.write_json(r)
end

function get_client_capabilities()
    local r = c_get_client_capabilities()
    http.write_json(r)
end

function get_bh_connection_status()
    local r = c_get_bh_connection_status()
    http.write_json(r)
end

function get_sta_steering_progress()
    local r = {}
    local fd = io.open("/tmp/sta_steer_progress","r")
    if not fd then
        r["status"] = "Failed to open /tmp/sta_steer_progress file in read mode!"
    else
        r["sta_steering_info"] = fd:read("*all")
        fd:close()
        r["status"] = "SUCCESS"
    end
    http.write_json(r)
end

function get_al_mac(devRole)
    local r = mtkwifi.get_easymesh_al_mac(devRole)
    http.write_json(r)
end

function apply_wifi_bh_priority(bhPriority2G, bhPriority5GL, bhPriority5GH)
    assert(bhPriority2G)
    assert(bhPriority5GL)
    assert(bhPriority5GH)
    debug_write("apply_wifi_bh_priority:BhPriority2G:"..bhPriority2G..", BhPriority5GL: "..bhPriority5GL..", BhPriority5GH: "..bhPriority5GH)
    local r = c_apply_wifi_bh_priority(bhPriority2G, bhPriority5GL, bhPriority5GH)
    if r.status == "SUCCESS" then
        local read_easymesh_cfgs = mtkwifi.load_profile(mtkwifi.__read_easymesh_profile_path())
        read_easymesh_cfgs['BhPriority2G'] = bhPriority2G
        read_easymesh_cfgs['BhPriority5GL'] = bhPriority5GL
        read_easymesh_cfgs['BhPriority5GH'] = bhPriority5GH
        mtkwifi.save_read_easymesh_profile(read_easymesh_cfgs)

        local write_easymesh_cfgs = mtkwifi.load_profile(mtkwifi.__write_easymesh_profile_path())
        write_easymesh_cfgs['BhPriority2G'] = bhPriority2G
        write_easymesh_cfgs['BhPriority5GL'] = bhPriority5GL
        write_easymesh_cfgs['BhPriority5GH'] = bhPriority5GH
        mtkwifi.save_write_easymesh_profile(write_easymesh_cfgs)
    end
    http.write_json(r)
end

function apply_ap_steer_rssi_th(rssi)
    assert(rssi)
    local r = c_apply_ap_steer_rssi_th(rssi)
    if r.status == "SUCCESS" then
        local easymesh_cfgs = mtkwifi.load_profile(mtkwifi.__read_easymesh_profile_path())
        if easymesh_cfgs['APSteerRssiTh'] ~= rssi then
            easymesh_cfgs['APSteerRssiTh'] = rssi
            mtkwifi.save_write_easymesh_profile(easymesh_cfgs)
        end
        local easymesh_mapd_cfgs = mtkwifi.load_profile(mtkwifi.__easymesh_mapd_profile_path())
        local mapd_rssi = tonumber(rssi) + 94
        if easymesh_mapd_cfgs['LowRSSIAPSteerEdge_RE'] ~= mapd_rssi then
            easymesh_mapd_cfgs['LowRSSIAPSteerEdge_RE'] = mapd_rssi
            mtkwifi.save_easymesh_mapd_profile(easymesh_mapd_cfgs)
        end
    end
    http.write_json(r)
end

function apply_force_ch_switch(agent_almac, channel1, channel2, channel3)
    agent_almac = agent_almac:sub(1,17)

    if channel1 == nil then
        channel1 = ""
    end

    if channel2 == nil then
        channel2 = ""
    end

    if channel3 == nil then
        channel3 = ""
    end

    debug_write("apply_force_ch_switch() enter, agent_almac: "..agent_almac..", channel1:"..channel1..", channel2:"..channel2..", channe3:"..channel3)
    local r = c_apply_force_ch_switch(agent_almac, channel1, channel2, channel3)
    debug_write("apply_force_ch_switch() status: "..r.status)
    http.write_json(r)
end

function apply_user_preferred_channel(channel)
    assert(channel)
    debug_write("apply_user_preferred_channel() enter, channel:"..channel)
    local r = c_apply_user_preferred_channel(channel)
    debug_write("apply_user_preferred_channel() status: "..r.status)
    http.write_json(r)
end

function trigger_channel_planning_r2(band)
    assert(band)
    local r = c_trigger_channel_planning_r2(band)
    http.write_json(r)
end

function trigger_de_dump(almac)
    assert(almac)
    local r = c_trigger_de_dump(almac)
    http.write_json(r)
end

function get_data_element()
    local r = c_get_data_element()
    http.write_json(r)
end

function trigger_channel_scan(almac)
    assert(almac)
    debug_write("trigger_channel_scan() enter, device AlMac:"..almac)
    local r = c_trigger_channel_scan(almac)
    debug_write("trigger_channel_scan() status: "..r.status)
    http.write_json(r)
end

function get_channel_stats()
    local r = c_get_channel_stats()
    http.write_json(r)
end

function get_channel_planning_score()
    local r = c_get_channel_planning_score()
    http.write_json(r)
end

function apply_channel_utilization_th(channelUtilTh2G, channelUtilTh5GL, channelUtilTh5GH)
    assert(channelUtilTh2G)
    assert(channelUtilTh5GL)
    assert(channelUtilTh5GH)
    local r = c_apply_channel_utilization_th(channelUtilTh2G, channelUtilTh5GL, channelUtilTh5GH)
    if r.status == "SUCCESS" then
        local easymesh_cfgs = mtkwifi.load_profile(mtkwifi.__read_easymesh_profile_path())
        if easymesh_cfgs['CUOverloadTh_2G'] ~= channelUtilTh2G or
           easymesh_cfgs['CUOverloadTh_5G_L'] ~= channelUtilTh5GL or
           easymesh_cfgs['CUOverloadTh_5G_H'] ~= channelUtilTh5GH then
            easymesh_cfgs['CUOverloadTh_2G'] = channelUtilTh2G
            easymesh_cfgs['CUOverloadTh_5G_L'] = channelUtilTh5GL
            easymesh_cfgs['CUOverloadTh_5G_H'] = channelUtilTh5GH
            mtkwifi.save_write_easymesh_profile(easymesh_cfgs)
        end
        local easymesh_mapd_cfgs = mtkwifi.load_profile(mtkwifi.__easymesh_mapd_profile_path())
        if easymesh_mapd_cfgs['CUOverloadTh_2G'] ~= channelUtilTh2G or
           easymesh_mapd_cfgs['CUOverloadTh_5G_L'] ~= channelUtilTh5GL or
           easymesh_mapd_cfgs['CUOverloadTh_5G_H'] ~= channelUtilTh5GH then
            easymesh_mapd_cfgs['CUOverloadTh_2G'] = channelUtilTh2G
            easymesh_mapd_cfgs['CUOverloadTh_5G_L'] = channelUtilTh5GL
            easymesh_mapd_cfgs['CUOverloadTh_5G_H'] = channelUtilTh5GH
            mtkwifi.save_easymesh_mapd_profile(easymesh_mapd_cfgs)
        end
    end
    http.write_json(r)
end

function get_sta_bh_interface()
    local r = mtkwifi.get_easymesh_on_boarded_iface_info()
    http.write_json(r)
end

function get_ap_bh_inf_list()
    local devs = mtkwifi.get_all_devs()
    local r = c_get_ap_bh_inf_list()
    if r.status == "SUCCESS" then
        r['apBhInfListStr'] = ""
        for mac in string.gmatch(r.macList, "(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x);") do
            for _, dev in ipairs(devs) do
                local bssid_without_lf = dev.apcli and dev.apcli.mac_addr:upper():sub(1,17) or ""
                if mac:upper() == bssid_without_lf then
                    r['apBhInfListStr'] = r['apBhInfListStr']..dev.apcli.vifname..';'
                else
                    for _,vif in ipairs(dev.vifs) do
                        bssid_without_lf = vif.__bssid:upper():sub(1,17)
                        if mac:upper() == bssid_without_lf then
                            r['apBhInfListStr'] = r['apBhInfListStr']..vif.vifname..';'
                        end
                    end
                end
            end
        end
    end
    http.write_json(r)
end

function get_ap_fh_inf_list()
    local devs = mtkwifi.get_all_devs()
    local r = c_get_ap_fh_inf_list()
    if r.status == "SUCCESS" then
        r['apFhInfListStr'] = ""
        for mac in string.gmatch(r.macList, "(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x);") do
            for _, dev in ipairs(devs) do
                local bssid_without_lf = dev.apcli and dev.apcli.mac_addr:upper():sub(1,17) or ""
                if mac:upper() == bssid_without_lf then
                    r['apFhInfListStr'] = r['apFhInfListStr']..dev.apcli.vifname..';'
                else
                    for _,vif in ipairs(dev.vifs) do
                        bssid_without_lf = vif.__bssid:upper():sub(1,17)
                        if mac:upper() == bssid_without_lf then
                            r['apFhInfListStr'] = r['apFhInfListStr']..vif.vifname..';'
                        end
                    end
                end
            end
        end
    end
    http.write_json(r)
end

function validate_easymesh_bss(r, cfgs, alMac, band)
    assert(type(r) == 'table')
    assert(type(cfgs) == 'table')
    assert(type(alMac) == 'string')
    assert(type(band) == 'string')
    if not cfgs[alMac] then
        r['status'] = 'SUCCESS'
    elseif not cfgs[alMac][band] then
        r['status'] = 'SUCCESS'
    else
        local numBss = mtkwifi.get_table_length(cfgs[alMac][band])
        if numBss >= 4 then
            r['status'] = 'No more BSS could be added!'
        else
            r['status'] = 'SUCCESS'
        end
    end
end

function validate_add_easymesh_bss_req(alMac, band)
    local r = {}
    local cfgs = mtkwifi.load_easymesh_bss_cfgs()
    if type(alMac) ~= 'string' then
        r["status"]= "Invalid AL-MAC Type "..type(alMac).." !"
    elseif type(band) ~= 'string' then
        r["status"]= "Invalid Band Type "..type(band).." !"
    else
        if type(cfgs) ~= "table" or next(cfgs) == nil then
            cfgs = {}
            cfgs['wildCardAlMacCfgs'] = {}
            cfgs['distinctAlMacCfgs'] = {}
        end
        if alMac == 'FF:FF:FF:FF:FF:FF' then
            validate_easymesh_bss(r, cfgs['wildCardAlMacCfgs'], alMac, band)
        else
            validate_easymesh_bss(r, cfgs['distinctAlMacCfgs'], alMac, band)
        end
    end
    if type(r) ~= 'table' or next(r) == nil then
        r['status'] = "Unexpected Exception in validate_easymesh_bss()!"
    end
    http.write_json(r)
end

function apply_easymesh_bss_cfg(isLocal)
    local r = c_apply_bss_config_renew()
    if r['status'] == 'SUCCESS' then
        local easymesh_bss_cfg_applied_path = mtkwifi.__profile_applied_settings_path(mtkwifi.__easymesh_bss_cfgs_path())
        os.execute("cp -f "..mtkwifi.__easymesh_bss_cfgs_path().." "..easymesh_bss_cfg_applied_path)
    end
    if isLocal then
        return r
    else
        luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "multi_ap", "easymesh_bss_config_renew"))
    end
end

function get_easymesh_bss_index(bssInfoTbl, bssInfoInp)
    assert(type(bssInfoTbl) == 'table')
    assert(type(bssInfoInp) == 'table')
    for bssIdx, bssInfo in pairs(bssInfoTbl) do
        debug_write("get SSID from wts_bss_info_config = "..bssInfo['ssid'])
        bssInfoInp['defPCP'] = "N/A"
        bssInfoInp['primVlan'] = "N/A"
        if  bssInfo['ssid'] == bssInfoInp['ssid'] and
            bssInfo['authMode'] == bssInfoInp['authMode'] and
            bssInfo['encType'] == bssInfoInp['encType'] and
            bssInfo['passPhrase'] == bssInfoInp['passPhrase'] and
            bssInfo['isBhBssSupported'] == bssInfoInp['isBhBssSupported'] and
            bssInfo['isFhBssSupported'] == bssInfoInp['isFhBssSupported'] and
            bssInfo['isHidden'] == bssInfoInp['isHidden'] and
            bssInfo['fhVlanId'] == bssInfoInp['fhVlanId'] and
            bssInfo['primVlan'] == bssInfoInp['primVlan'] and
            bssInfo['defPCP'] == bssInfoInp['defPCP'] then
            return bssIdx
        end
    end
    return nil
end

function update_easymesh_bss(cfgs, bssInfoInp, isEdit)
    assert(type(cfgs) == 'table')
    assert(type(bssInfoInp) == 'table')
    assert(type(isEdit) == 'string')
    if not cfgs[bssInfoInp['alMac']] then
        cfgs[bssInfoInp['alMac']] = {}
    end
    if not cfgs[bssInfoInp['alMac']][bssInfoInp['band']] then
        cfgs[bssInfoInp['alMac']][bssInfoInp['band']] = {}
    end
    local bssInfoTbl = cfgs[bssInfoInp['alMac']][bssInfoInp['band']]
    local bssInfoIdx
    if isEdit == "1" then
        local editBssInfo = {}
        local tmpEditSSID = http.formvalue('__EDIT_SSID'):gsub("\\", "\\\\")
        editBssInfo['ssid'] = tmpEditSSID:gsub("%s+","\\ ")
        debug_write("get edited SSID from UI = "..editBssInfo['ssid'])
        editBssInfo['authMode'] = http.formvalue('__EDIT_AUTH_MODE')
        editBssInfo['encType'] = http.formvalue('__EDIT_ENCRYPTION_TYPE')
        local tmpEditPassPhrase = http.formvalue('__EDIT_PASS_PHRASE'):gsub("\\", "\\\\")
        editBssInfo['passPhrase'] = tmpEditPassPhrase:gsub("%s+","\\ ")
        editBssInfo['isBhBssSupported'] = http.formvalue('__EDIT_BH_SUPPORT')
        editBssInfo['isFhBssSupported'] = http.formvalue('__EDIT_FH_SUPPORT')
        editBssInfo['isHidden'] = http.formvalue('__EDIT_IS_SSID_HIDDEN')
        editBssInfo['fhVlanId'] = http.formvalue('__EDIT_FH_VLAN_ID')
        editBssInfo['primVlan'] = http.formvalue('__EDIT_PRIM_VLAN')
        editBssInfo['defPCP'] = http.formvalue('__EDIT_DEF_PCP')
        bssInfoIdx = get_easymesh_bss_index(bssInfoTbl, editBssInfo)
        assert(bssInfoIdx)
        assert(type(bssInfoTbl[bssInfoIdx]) == 'table')
    else
        bssInfoIdx = mtkwifi.get_table_length(bssInfoTbl) + 1
        bssInfoTbl[bssInfoIdx] = {}
    end
    local bssInfo = bssInfoTbl[bssInfoIdx]
    bssInfo['ssid'] = bssInfoInp['ssid']
    debug_write("final SSID write to wts_bss_info_config = "..bssInfo['ssid'])
    bssInfo['authMode'] = bssInfoInp['authMode']
    bssInfo['encType'] = bssInfoInp['encType']
    bssInfo['passPhrase'] = bssInfoInp['passPhrase'] and bssInfoInp['passPhrase'] ~= '' and bssInfoInp['passPhrase'] or '12345678'
    bssInfo['isBhBssSupported'] = bssInfoInp['isBhBssSupported']
    bssInfo['isFhBssSupported'] = bssInfoInp['isFhBssSupported']
    bssInfo['isHidden'] = bssInfoInp['isHidden']
    bssInfo['fhVlanId'] = bssInfoInp['fhVlanId']
    bssInfo['primVlan'] = bssInfoInp['primVlan']
    bssInfo['defPCP'] = bssInfoInp['defPCP']

end

function easymesh_bss_cfg()
    local cfgs = mtkwifi.load_easymesh_bss_cfgs()

    local bssInfoInp = {}
    for k,v in pairs(http.formvalue()) do
        if type(v) ~= type("") and type(v) ~= type(0) then
            debug_write("easymesh_bss_cfg: Input BSSINFO are of incorrect type!",k,v)
        elseif string.byte(k) ~= string.byte("_") then
            bssInfoInp[k] = v
        end
    end

    if bssInfoInp['primVlan'] ~= "N/A" and bssInfoInp['defPCP'] ~= "N/A" then
        for alMac,alMacTbl in pairs(cfgs['wildCardAlMacCfgs']) do
            for band,bssInfoTbl in pairs(alMacTbl) do
                for _,bssInfo in pairs(bssInfoTbl) do
                    bssInfo['primVlan'] = "N/A"
                    bssInfo['defPCP'] = "N/A"
                end
            end
        end

        for alMac,alMacTbl in pairs(cfgs['distinctAlMacCfgs']) do
            for band,bssInfoTbl in pairs(alMacTbl) do
                for _,bssInfo in pairs(bssInfoTbl) do
                    bssInfo['primVlan'] = "N/A"
                    bssInfo['defPCP'] = "N/A"
                end
            end
        end
    end

    debug_write("original SSID which user entered = "..bssInfoInp['ssid'])
    local tmpSSID = bssInfoInp['ssid']:gsub("\\", "\\\\")
    bssInfoInp['ssid'] = tmpSSID:gsub("%s+","\\ ")
    debug_write("get SSID from UI = "..bssInfoInp['ssid'])
    local tmpPassPhrase = bssInfoInp['passPhrase']:gsub("\\", "\\\\")
    bssInfoInp['passPhrase'] = tmpPassPhrase:gsub("%s+","\\ ")
    if type(cfgs) ~= "table" or next(cfgs) == nil then
        cfgs = {}
        cfgs['wildCardAlMacCfgs'] = {}
        cfgs['distinctAlMacCfgs'] = {}
    end
    if bssInfoInp['alMac'] == 'FF:FF:FF:FF:FF:FF' then
        update_easymesh_bss(cfgs['wildCardAlMacCfgs'], bssInfoInp, http.formvalue('__IS_EDIT'))
    else
        update_easymesh_bss(cfgs['distinctAlMacCfgs'], bssInfoInp, http.formvalue('__IS_EDIT'))
    end
    mtkwifi.save_easymesh_bss_cfgs(cfgs)
    if http.formvalue("__apply") then
        apply_easymesh_bss_cfg(true)
    end
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "multi_ap", "easymesh_bss_config_renew"))
end

function remove_easymesh_bss(r,cfgs,bssInfoInp)
    assert(type(r) == 'table')
    assert(type(cfgs) == 'table')
    assert(type(bssInfoInp) == 'table')
    for alMac,alMacTbl in pairs(cfgs) do
        if alMac == bssInfoInp['alMac'] then
            assert(type(alMacTbl) == 'table')
            for band,bssInfoTbl in pairs(alMacTbl) do
                if bssInfoInp['primVlan'] ~= "N/A" and bssInfoInp['defPCP'] ~= "N/A" then
                    for _,bssInfo in pairs(bssInfoTbl) do
                        bssInfo['primVlan'] = "N/A"
                        bssInfo['defPCP'] = "N/A"
                    end
                end
                if band == bssInfoInp['band'] then
                    assert(type(bssInfoTbl) == 'table')
                    local bssIdx = get_easymesh_bss_index(bssInfoTbl, bssInfoInp)
                    if bssIdx then
                        local alMacTblLen = mtkwifi.get_table_length(alMacTbl)
                        local bssInfoTblLen = mtkwifi.get_table_length(bssInfoTbl)
                        if bssInfoTblLen == 1 then
                            cfgs[alMac][band] = nil
                            if alMacTblLen == 1 then
                                cfgs[alMac] = nil
                            end
                        else
                            table.remove(cfgs[alMac][band], tonumber(bssIdx))
                        end
                        r['status'] = 'SUCCESS'
                    else
                        r['status'] = 'ERROR: BSSINFO does not exist!'
                    end
                    break
                end
            end
            if next(r) == nil then
                r['status'] = 'ERROR: BAND does not exist!'
            end
            break
        end
    end
    if next(r) == nil then
        r['status'] = 'ERROR: AL-MAC does not exist!'
    end
end

function remove_easymesh_bss_cfg_req()
    local r = {}
    local cfgs = mtkwifi.load_easymesh_bss_cfgs()
    if type(cfgs) ~= "table" or next(cfgs) == nil then
        r["status"]= mtkwifi.__easymesh_bss_cfgs_path().." file not found!"
    else
        local bssInfoInp = {}
        for k,v in pairs(http.formvalue()) do
            if type(v) ~= type("") and type(v) ~= type(0) then
                r["status"]= "Input BSSINFO are of incorrect type!"
                break
            elseif string.byte(k) ~= string.byte("_") then
                bssInfoInp[k] = v
            end
        end
        local tmpSSID = bssInfoInp['ssid']:gsub("\\", "\\\\")
        bssInfoInp['ssid'] = tmpSSID:gsub("%s+","\\ ")
        local tmpPassPhrase = bssInfoInp['passPhrase']:gsub("\\", "\\\\")
        bssInfoInp['passPhrase'] = tmpPassPhrase:gsub("%s+","\\ ")
        if next(r) == nil then
            if bssInfoInp['alMac'] == 'FF:FF:FF:FF:FF:FF' then
                remove_easymesh_bss(r, cfgs['wildCardAlMacCfgs'], bssInfoInp)
            else
                remove_easymesh_bss(r, cfgs['distinctAlMacCfgs'], bssInfoInp)
            end
        end
    end
    if type(r) ~= 'table' or next(r) == nil then
        r['status'] = "Unexpected Exception in remove_easymesh_bss()!"
    else
        mtkwifi.save_easymesh_bss_cfgs(cfgs)
        r = apply_easymesh_bss_cfg(true)
    end
    http.write_json(r)
end

function get_user_preferred_channel()
    local r = c_get_user_preferred_channel()
    http.write_json(r)
end

function get_sp_rule_list()
    local r = c_get_sp_rule_list()
    http.write_json(r)
end

function del_sp_rule(index)
    if index == nil then
        index = ""
    end
    local r = c_del_sp_rule(index)
    http.write_json(r)
end

function sp_rule_reorder(index1, index2)
    local r = c_sp_rule_reorder(index1, index2)
    http.write_json(r)
end

function sp_rule_move(index, action)
    local r = c_sp_rule_move(index, action)
    http.write_json(r)
end

function sp_rule_add(str_rule)
    str_rule = string.gsub(str_rule, "] ", "]+")
    local r = c_sp_rule_add(str_rule)
    http.write_json(r)
end

function sp_config_done()
    local r = c_sp_config_done()
    http.write_json(r)
end

function submit_dpp_uri()
    uri = http.formvalue("uri")
    os.execute("wappctrl ra0 dpp dpp_qr_code ".."\""..uri.."\"")
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "multi_ap"))
end

function start_dpp_onboarding()
    os.execute("wappctrl ra0 dpp dpp_start")
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "multi_ap"))
end

function generate_dpp_uri()
    os.execute("wappctrl ra0 dpp dpp_bootstrap_gen type=qrcode")
    luci.http.redirect(luci.dispatcher.build_url("admin", "mtk", "multi_ap"))
end

function retrive_dpp_uri()
    local result = mtkwifi.read_pipe(tostring("mapd_cli /tmp/mapd_ctrl get_dpp_uri").." 2>&1")
    result = result:gsub("<", "&lt;")
    http.write(tostring(result))
end