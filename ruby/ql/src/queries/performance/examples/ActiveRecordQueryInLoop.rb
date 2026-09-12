def get_podcast_names(user):
    user.podcasts.map do |podcast|
        podcast.name
    end
end
