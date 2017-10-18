source "https://rubygems.org"

# These are required to generate the site (enough for CI)
gem 'rake'
gem 'jekyll'
gem 'jekyll-paginate'

# These are only needed when content authoring is needed
group :author, optional: true do
    gem 'trollop'
    gem 'rmagick'
end

# TODO: These are most likely outdated. Check.
group :development, optional: true do
    gem 'guard'
    gem 'guard-livereload'

    gem 'rb-fsevent', :require => false
    gem 'rb-inotify', :require => false
end
