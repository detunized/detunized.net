require 'rmagick'

module Convert
    # Image
    JPEG_QUALITY = 85

    # Copyright
    COPYRIGHT = "\u00a9 Dmitry Yakimenko (detunized.net)"
    FONT = 'Tahoma-Normal'
    FONT_SIZE = 17
    TEXT_COLOR = '#eee'
    SHADOW_COLOR = '#5557'
    OFFSET_X = 10
    OFFSET_Y = 10

    def self.convert src, dst, options = {}
        image = Magick::Image.read(src).first

        # Poor man's shadow
        Magick::Draw.new.annotate(image, 0, 0, image.columns - OFFSET_X - 1, image.rows - OFFSET_Y + 1, COPYRIGHT) do
            self.font = FONT
            self.pointsize = FONT_SIZE
            self.fill = SHADOW_COLOR
            self.rotation = -90
        end

        # Text
        Magick::Draw.new.annotate(image, 0, 0, image.columns - OFFSET_X, image.rows - OFFSET_Y, COPYRIGHT) do
            self.font = FONT
            self.pointsize = FONT_SIZE
            self.fill = TEXT_COLOR
            self.rotation = -90
        end

        puts "Converting '#{src}' to '#{dst}'" if options[:verbose]

        image.write dst do
            self.quality = JPEG_QUALITY
        end
    end
end
