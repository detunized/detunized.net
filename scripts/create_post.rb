#!/usr/bin/env ruby

# TODO:
#  - Create folders and name files appropriately (currently relies on the existing structure)
#  - Fix todos in the code

require 'date'
require 'trollop'
require 'yaml'

ROOT = File.exists?('./_posts') ? './' : '../'
GALLERY_PATH = File.join ROOT, 'galleries'
POST_PATH = File.join ROOT, '_posts'

if not File.exists? POST_PATH
    puts 'The script must be run from the root of the repo or from scripts'
    exit
end

# Parse command-line parameters
parameters = Trollop::options do
    # Required
    opt 'name',        'Gallery name',                                    :type => :string, :required => true
    opt 'event-date',  'Event date (YYYY-MM-DD)',                         :type => :string, :required => true
    opt 'image-path',  'Path to images (/\d+\.jpg/)',                     :type => :string, :required => true

    # Optional
    opt 'post-date',   'Override post date (YYYY-MM-DD, default is now)', :type => :string
    opt 'description', 'Gallery description',                             :type => :string
    opt 'banner',      'Banner filename (default is <name>.jpg)',         :type => :string
    opt 'move-images', 'Move images instead of copying them'
end

# TODO: Catch exceptions when the date is incorrect
event_date = DateTime.strptime(parameters['event-date'], "%Y-%m-%d")
post_date = parameters['post-date'] ? DateTime.strptime(parameters['post-date'], "%Y-%m-%d") : DateTime.now

# Sanitize 'Cool and Awesome Gallery!!!' to 'cool-and-awesome-gallery'
# TODO: Replace accented characters with their simple equivalents rather then with '-'
sanitized_name = parameters['name'].downcase.gsub(/[^a-z0-9]/, '-').sub(/^-+/, '').sub(/-+$/, '').gsub(/-+/, '-')

# Convert 'Cool and Awesome Gallery!!!' to '2012-10-30-cool-and-awesome-gallery-july-2011'
post_slug = [post_date.strftime('%Y-%m-%d'), sanitized_name, event_date.strftime('%B-%Y')].join('-').downcase

# TODO: Check that there are some images present
# TODO: Check that there are no strangely named images
images = Dir[File.join parameters['image-path'], '[0-9][0-9][0-9]-*.jpg'].map { |i| File.basename i }

# YAML front matter
post = {
    'layout'      => 'post',
    'title'       => "#{parameters['name']}, #{event_date.strftime '%B %Y'}",
    'description' => parameters['description'],
    'event_date'  => event_date.strftime('%Y-%m-%d'),
    'folder'      => "#{event_date.strftime '%Y-%m-%d'}-#{sanitized_name}",
    'images'      => images
}

# Generate post HTML (which has no HTML, just YAML front matter)
File.open File.join(POST_PATH, "#{post_slug}.html"), 'w' do |io|
    io.puts post.to_yaml
    io.puts '---'
end
