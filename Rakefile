task :default => :generate

task :generate do
    sh "jekyll"
end

task :deploy => :generate do
    sh "rsync -avPk --delete -e ssh _site/ detunized.net:www/detunized.net/new_blog/"
end

task :backup do
    sh "rsync -avPk _site/ ~/Dropbox/detunized.net/"
end

task :server do
    sh "bundle exec jekyll --server --auto --url http://localhost:4000 --base-url /new_blog"
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
    sh %q(tmux kill-session -t server)
end
