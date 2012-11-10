task :default => :generate

task :generate do
    sh "jekyll"
end

task :deploy => :generate do
    sh "rsync -avP --delete -e ssh _site/* detunized.net:www/detunized.net/new_blog/"
end
