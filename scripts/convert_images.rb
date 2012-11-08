#!/usr/bin/env ruby

require 'rake'
require 'rmagick'

# Image
WIDTH = 900
HEIGHT = 600
JPEG_QUALITY = 85

# Copyright
COPYRIGHT = "\u00a9 Dmitry Yakimenko (detunized.net)"
FONT = 'Tahoma-Normal'
FONT_SIZE = 17
OFFSET_X = 10
OFFSET_Y = 10

# File
IMAGE_DIR = File.join ENV['HOME'], 'temp', 'lightroom-export'

def convert src, dst
    image = Magick::Image.read(src).first

    # Resize
    image.resize! WIDTH, HEIGHT

    # Poor man's shadow
    Magick::Draw.new.annotate(image, 0, 0, image.columns - OFFSET_X - 1, image.rows - OFFSET_Y + 1, COPYRIGHT) do
        self.font = FONT
        self.pointsize = FONT_SIZE
        self.fill = '#5557'
        self.rotation = -90
    end

    # Text
    Magick::Draw.new.annotate(image, 0, 0, image.columns - OFFSET_X, image.rows - OFFSET_Y, COPYRIGHT) do
        self.font = FONT
        self.pointsize = FONT_SIZE
        self.fill = '#eee'
        self.rotation = -90
    end

    image.write dst do
        self.quality = JPEG_QUALITY
    end
end

# Covert original TIFF files to JPEG
Dir[File.join IMAGE_DIR, '[0-9][0-9][0-9].tif'].each do |tiff|
    convert tiff, tiff.pathmap('%X.jpg')
end
