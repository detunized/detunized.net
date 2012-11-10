#!/usr/bin/env ruby

# TODO:
#  - Create folders and name files appropriately (currently relies on the existing structure)
#  - Fix todos in the code

require 'date'
require 'rake'
require 'yaml'
require 'trollop'

require_relative 'convert'

ROOT = File.exists?('./_posts') ? './' : '../'
GALLERY_PATH = File.join ROOT, 'galleries'
POST_PATH = File.join ROOT, '_posts'

if not File.exists? POST_PATH
    abort 'The script must be run from the root of the repo or from scripts'
end

# Parse command-line parameters
parameters = Trollop.options do
    # Required
    opt 'name',
        'Gallery name',
        :required => true,
        :type => :string

    opt 'event-date',
        'Event date (YYYY-MM-DD)',
        :required => true,
        :type => :string

    opt 'image-path',
        'Path to images (NNN.tif or NNN.jpg with --no-convert)',
        :required => true,
        :type => :string

    # Optional
    opt 'post-date',
        'Override post date (YYYY-MM-DD, default is now)',
        :type => :string

    opt 'description',
        'Gallery description',
        :type => :string

    # TODO: Make required
    opt 'banner',
        'Banner filename (default is <name>.jpg)',
        :type => :string

    opt 'force',
        'Overwrite files if they already preset'

    opt 'convert',
        'Convert images from to TIFF to JPEG, resize and apply the copyright watermark',
        :default => true

    opt 'move-images',
        'Move images instead of copying them'
end

# TODO: Catch exceptions when the date is incorrect
event_date = DateTime.strptime(parameters['event-date'], "%Y-%m-%d")
post_date = parameters['post-date'] ? DateTime.strptime(parameters['post-date'], "%Y-%m-%d") : DateTime.now

# Sanitize 'Cool and Awesome Gallery!!!' to 'cool-and-awesome-gallery'
# TODO: Replace accented characters with their simple equivalents rather then with '-'
sanitized_name = parameters['name'].downcase.gsub(/[^a-z0-9]/, '-').sub(/^-+/, '').sub(/-+$/, '').gsub(/-+/, '-')

# Convert 'Cool and Awesome Gallery!!!' to '2012-10-30-cool-and-awesome-gallery-july-2011'
post_slug = [post_date.strftime('%Y-%m-%d'), sanitized_name, event_date.strftime('%B-%Y')].join('-').downcase

# Gallery subdirectory
gallery_subdir = "#{event_date.strftime '%Y-%m-%d'}-#{sanitized_name}"

# TODO: Check that there are some images present
# TODO: Check that there are no strangely named images
src_images = Dir[File.join parameters['image-path'], "[0-9][0-9][0-9]." + (parameters['convert'] ? 'tif' : 'jpg')]
dst_images = src_images.map { |i| i.pathmap "%n-#{sanitized_name}.jpg" }

if src_images.empty?
    abort "No images found at '#{parameters['image-path']}'"
end

# Fail if gallery exists already, unless run with --force
gallery_path = File.join GALLERY_PATH, gallery_subdir
if File.exists? gallery_path
    if parameters['force']
        rm_rf gallery_path
        if File.exists? gallery_path
            abort "Cannot remove '#{gallery_path}'"
        end
    else
        abort "'#{gallery_path}' already exists (use --force, Luke)"
    end
end

# Convert, copy or move images to the destination
mkdir_p gallery_path
src_images.each_with_index do |image, index|
    dst = File.join(gallery_path, dst_images[index])

    if parameters['convert']
        Convert.convert image, dst, :verbose => true
    elsif parameters['move-images']
        mv image, dst
    else
        cp image, dst
    end
end

# YAML front matter
post = {
    'layout'      => 'post',
    'title'       => "#{parameters['name']}, #{event_date.strftime '%B %Y'}",
    'description' => parameters['description'],
    'event_date'  => event_date.strftime('%Y-%m-%d'),
    'folder'      => gallery_subdir,
    'images'      => dst_images
}

# Generate post HTML (which has no HTML, just YAML front matter)
File.open File.join(POST_PATH, "#{post_slug}.html"), 'w' do |io|
    io.puts post.to_yaml
    io.puts '---'
end
