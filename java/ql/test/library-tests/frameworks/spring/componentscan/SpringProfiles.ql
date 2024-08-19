import java
import SpringProfiles

from SpringProfileExpr springProfileExpr, string active
where if springProfileExpr.isActive() then active = "active" else active = "inactive"
select springProfileExpr, springProfileExpr.getProfile(), active
