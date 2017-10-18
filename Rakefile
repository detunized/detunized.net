task :default => :generate

task :setup do
    def installed? command
        system "which #{command} >/dev/null"
    end

    # Install dependencies
    sh "brew install tmux" unless installed? "tmux"
    sh "brew install imagemagick --with-libtiff --with-quantum-depth-16" unless installed? "convert"
    sh "bundle install"

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

task :start do
    sh %q(tmux new-session -d -s server -n window "rake server" \\; set-option remain-on-exit on)
    sh %q(tmux split-window -v -t server:window "rake live_reload")
    sh %q(tmux attach-session -t server)
end

task :stop do
    sh %q(tmux send-keys -t server:window.0 "C-c")
    sh %q(tmux send-keys -t server:window.1 "C-c")
    sleep 2
    sh %q(tmux kill-window -t server:window)
end
