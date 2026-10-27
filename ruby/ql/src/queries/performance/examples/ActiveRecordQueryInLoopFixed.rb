def get_podcast_names(user):
    user.podcasts.includes(:name).map do |podcast|
        podcast.name
    end
end
