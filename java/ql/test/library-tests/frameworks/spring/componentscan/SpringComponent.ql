import java
import SpringProfiles

from SpringComponent springComponent, string isLive
where if springComponent.isLive() then isLive = "live" else isLive = "dead"
select springComponent, isLive
