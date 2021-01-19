// routeros
var bad = /(\.\.\/|\/|\s)((traffic-flow|traffic-generator|firewall|scheduler|aaa|accounting|address-list|address|align|area|bandwidth-server|bfd|bgp|bridge|client|clock|community|config|connection|console|customer|default|dhcp-client|dhcp-server|discovery|dns|e-mail|ethernet|filter|firewall|firmware|gps|graphing|group|hardware|health|hotspot|identity|igmp-proxy|incoming|instance|interface|ip|ipsec|ipv6|irq|l2tp-server|lcd|ldp|logging|mac-server|mac-winbox|mangle|manual|mirror|mme|mpls|nat|nd|neighbor|network|note|ntp|ospf|ospf-v3|ovpn-server|page|peer|pim|ping|policy|pool|port|ppp|pppoe-client|pptp-server|prefix|profile|proposal|proxy|queue|radius|resource|rip|ripng|route|routing|screen|script|security-profiles|server|service|service-port|settings|shares|smb|sms|sniffer|snmp|snooper|socks|sstp-server|system|tool|tracking|type|upgrade|upnp|user-manager|users|user|vlan|secret|vrrp|watchdog|web-access|wireless|pptp|pppoe|lan|wan|layer7-protocol|lease|simple|raw);?\s)+X/;
var good = /(\.\.\/|\/|\s)((traffic-flow|traffic-generator|firewall|scheduler|aaa|accounting|address-list|address|align|area|bandwidth-server|bfd|bgp|bridge|client|clock|community|config|connection|console|customer|default|dhcp-client|dhcp-server|discovery|dns|e-mail|ethernet|filter|firmware|gps|graphing|group|hardware|health|hotspot|identity|igmp-proxy|incoming|instance|interface|ip|ipsec|ipv6|irq|l2tp-server|lcd|ldp|logging|mac-server|mac-winbox|mangle|manual|mirror|mme|mpls|nat|nd|neighbor|network|note|ntp|ospf|ospf-v3|ovpn-server|page|peer|pim|ping|policy|pool|port|ppp|pppoe-client|pptp-server|prefix|profile|proposal|proxy|queue|radius|resource|rip|ripng|route|routing|screen|script|security-profiles|server|service|service-port|settings|shares|smb|sms|sniffer|snmp|snooper|socks|sstp-server|system|tool|tracking|type|upgrade|upnp|user-manager|users|user|vlan|secret|vrrp|watchdog|web-access|wireless|pptp|pppoe|lan|wan|layer7-protocol|lease|simple|raw);?\s)+X/;

// powershell
var bad = /(Add|Clear|Close|Copy|Enter|Exit|Find|Format|Get|Hide|Join|Lock|Move|New|Open|Optimize|Pop|Push|Redo|Remove|Rename|Reset|Resize|Search|Select|Set|Show|Skip|Split|Step|Switch|Undo|Unlock|Watch|Backup|Checkpoint|Compare|Compress|Convert|ConvertFrom|ConvertTo|Dismount|Edit|Expand|Export|Group|Import|Initialize|Limit|Merge|New|Out|Publish|Restore|Save|Sync|Unpublish|Update|Approve|Assert|Complete|Confirm|Deny|Disable|Enable|Install|Invoke|Register|Request|Restart|Resume|Start|Stop|Submit|Suspend|Uninstall|Unregister|Wait|Debug|Measure|Ping|Repair|Resolve|Test|Trace|Connect|Disconnect|Read|Receive|Send|Write|Block|Grant|Protect|Revoke|Unblock|Unprotect|Use|ForEach|Sort|Tee|Where)+(-)[\w\d]+/;
var good = /(Add|Clear|Close|Copy|Enter|Exit|Find|Format|Get|Hide|Join|Lock|Move|New|Open|Optimize|Pop|Push|Redo|Remove|Rename|Reset|Resize|Search|Select|Set|Show|Skip|Split|Step|Switch|Undo|Unlock|Watch|Backup|Checkpoint|Compare|Compress|Convert|ConvertFrom|ConvertTo|Dismount|Edit|Expand|Export|Group|Import|Initialize|Limit|Merge|Out|Publish|Restore|Save|Sync|Unpublish|Update|Approve|Assert|Complete|Confirm|Deny|Disable|Enable|Install|Invoke|Register|Request|Restart|Resume|Start|Stop|Submit|Suspend|Uninstall|Unregister|Wait|Debug|Measure|Ping|Repair|Resolve|Test|Trace|Connect|Disconnect|Read|Receive|Send|Write|Block|Grant|Protect|Revoke|Unblock|Unprotect|Use|ForEach|Sort|Tee|Where)+(-)[\w\d]+/;

// perl
var bad = /(s|tr|y)\/(\\.|[^/])*\/(\\.|[^/])*\/[a-z]*/m;
var good = /(s|tr|y)\/(\\.|[^\\\/])*\/(\\.|[^\\\/])*\/[dualxmsipn]{0,12}/m;

// gams
var bad = /([ ]*[a-z0-9&#*=?@\\><:,()$[\]_.{}!+%^-]+)+X/;
var good = /[a-z0-9&#*=?@\\><:,()$[\]_.{}!+%^-]+([ ]+[a-z0-9&#*=?@\\><:,()$[\]_.{}!+%^-]+)*/im;

// handlebars
var bad = /('.*?'|".*?"|\[.*?\]|[^\s!"#%&'()*+,.\/;<=>@\[\\\]^`{|}~]+|\.|\/)+X/;
var good = /(\.|\.\/|\/)?(""|"[^"]+"|''|'[^']+'|\[\]|\[[^\]]+\]|[^\s!"#%&'()*+,.\/;<=>@\[\\\]^`{|}~]+)((\.|\/)(""|"[^"]+"|''|'[^']+'|\[\]|\[[^\]]+\]|[^\s!"#%&'()*+,.\/;<=>@\[\\\]^`{|}~]+))*/im;

// c-like
var bad = /((decltype\(auto\)|(?:[a-zA-Z_]\w*::)?[a-zA-Z_]\w*(?:<.*?>)?)[\*&\s]+)+(?:[a-zA-Z_]\w*::)?[a-zA-Z]\w*\s*\(/m;
var good = /((decltype\(auto\)|([a-zA-Z_]\w*::)?[a-zA-Z_]\w*(<[^<>]+>)?)[\*&\s]+)+([a-zA-Z_]\w*::)?[a-zA-Z]\w*\s*\(/m;

// jboss-cli
var bad = /\B(([\/.])[\w\-.\/=]+)+X/;
var good = /\B([\/.])[\w\-.\/=]+X/;

// r
var bad = /`(?:\\.|[^`])+`/m;
var good = /`(?:\\.|[^`\\])+`/;

// erlang-repl
var bad = /\?(::)?([A-Z]\w*(::)?)+X/;
var good = /\?(::)?([A-Z]\w*)((::)[A-Z]\w*)*X/;

// javascript
var bad = /[a-zA-Z_]\w*\([^()]*(\([^()]*(\([^()]*\))*[^()]*\))*[^()]*\)\s*\{/m;
var good = /[a-zA-Z_]\w*\([^()]*(\([^()]*(\([^()]*\)[^()]*)*\)[^()]*)*\)\s*\{/m;
