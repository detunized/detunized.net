#!/usr/bin/env ruby

require 'rake'

SRC_DIR = '../../detunized.net'
DST_DIR = '../galleries'

def image_filenames_simpleviewer gallery_path
    gallery_xml = File.read File.join gallery_path, 'gallery.xml'
    image_path = gallery_xml[%r{imagePath="(.*?)"}, 1]
    gallery_xml.scan(%r{<filename>(.*?)</filename>})
        .flatten
        .map { |image| File.join gallery_path, image_path, image }
end

def image_filenames_html gallery_path
    Dir[File.join gallery_path, 'index*.html']
        .sort
        .map { |index| File.read(index).scan %r{<a href="(content/.*?.html)"} }
        .flatten
        .map { |page|
            html = File.join gallery_path, page
            image = File.read(html)[%r{<img src="(bin/images/large/.*?)"}, 1]

            File.join File.dirname(html), image
        }
end

def image_filenames gallery_path
    if File.exists? File.join gallery_path, 'gallery.xml'
        image_filenames_simpleviewer gallery_path
    else
        image_filenames_html gallery_path
    end
end

# Clean first
rm_rf DST_DIR

# Copy images
Dir[File.join SRC_DIR, 'photo', '[0-9][0-9][0-9][0-9]*'].each do |dir|
    original_name = File.basename dir
    year, month, name = original_name.match(/(\d{4})-(\d{2})-(.*)/).captures
    name = name.gsub('_', '-')
    title = name.gsub('-', ' ').split(' ').map(&:capitalize).join ' '

    gallery_dir = File.join DST_DIR, "#{year}-#{month}-01-#{name}"

    # Copy the photos
    mkdir_p gallery_dir
    image_filenames(dir).each_with_index do |image, index|
        cp image, File.join(gallery_dir, "%03d-#{name}.jpg" % (index + 1))
    end

    # Copy the banner
    cp File.join(dir, "#{original_name}.jpg"), File.join(gallery_dir, "title.jpg")

    # Create a post for this gallery
    sh "./create_post.rb --name '#{title}'" \
                       " --event-date '#{year}-#{month}-01'" \
                       " --post-date '#{year}-#{month}-01'" \
                       " --image-path '#{gallery_dir}'"
end
