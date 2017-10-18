task :default => :generate

task :setup do
    def installed? command
        system "which #{command} >/dev/null"
    end

    # Install dependencies
    sh "brew install imagemagick@6"
    sh "brew link --force imagemagick@6"
    sh "bundle install --with author --path vendor"

    # Copy data from Dropbox and normalize permissions
    sh "rsync -avP ~/Dropbox/detunized.net/galleries ./"
    sh "find galleries -type d ! -perm 755 -print0 | xargs -0 chmod 755"
    sh "find galleries -type f ! -perm 644 -print0 | xargs -0 chmod 644"
end

task :generate do
    sh "bundle exec jekyll build"
end

task :deploy => :generate do
    sh "rsync -avPk -e ssh _site/ raw.seedhost.eu:www/detunized.raw.seedhost.eu/detunized/detunized.net/"
end

task :backup => :generate do
    sh "rsync -avPk --delete _site/ ~/Dropbox/detunized.net/"
end

task :server => :generate do
    sh "bundle exec jekyll serve --watch"
end

task :live_reload do
    sh "bundle exec guard -i"
end
