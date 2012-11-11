task :default => :generate

task :generate do
    sh "jekyll"
end

task :deploy => :generate do
    sh "rsync -avP --delete -e ssh _site/* detunized.net:www/detunized.net/new_blog/"
end

task :backup do
    sh "rsync -avPk _site/ ~/Dropbox/detunized.net/"
end

task :server do
    sh "jekyll --server --auto"
end

task :live_reload do
    sh "bundle exec guard -i"
end
