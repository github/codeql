# Preload User data
user_data = User.where(login: repo_names_by_owner.keys).pluck(:login, :id, :type).to_h do |login, id, type|
  [login, { id: id, type: type == "User" ? "USER" : "ORGANIZATION" }]
end

repo_names_by_owner.each do |owner_slug, repo_names|
  owner_info = user_data[owner_slug]
  owner_id = owner_info[:id]
  owner_type = owner_info[:type]
  rel_conditions = { owner_id: owner_id, name: repo_names }

  nwo_rel = nwo_rel.or(RepositorySecurityCenterConfig.where(rel_conditions)) unless neg
  nwo_rel = nwo_rel.and(RepositorySecurityCenterConfig.where.not(rel_conditions)) if neg
end