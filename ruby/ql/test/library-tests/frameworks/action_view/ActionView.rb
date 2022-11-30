
def setup_view_paths
  view_path =  Rails.root.join("/path/to/views")
  pattern = ":prefix/:action{.:formats,}"
  ActionController::Base.view_paths = ActionView::FileSystemResolver.new(view_path, pattern)
end