repo_names_by_owner.map do |owner_slug, repo_names|
    owner_id, owner_type = User.where(login: owner_slug).pluck(:id, :type).first
    owner_type = owner_type == "User" ? "USER" : "ORGANIZATION"
    rel_conditions = { owner_id: owner_id, name: repo_names }

    nwo_rel = nwo_rel.or(RepositorySecurityCenterConfig.where(rel_conditions)) unless neg
    nwo_rel = nwo_rel.and(RepositorySecurityCenterConfig.where.not(rel_conditions)) if neg
  end