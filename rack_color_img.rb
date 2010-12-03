require 'RMagick'
require 'open-uri'

module Rack
  class ColorImg
    def initialize(app)
      @app = app
    end
    def call(env)
      if colors = env["PATH_INFO"].match(%r{/hue_img/(\d{1,3})\.png})
        request = Rack::Request.new(env)
        # we should really set an early timeout here because we aren't
        # using event machine.  This could hang too long for our
        # taste.
        # however I will be using this for known images.
        
        img = open(request.params['src'])
        source = Magick::Image.from_blob(img.read).first
        width = source.columns
        height = source.rows
        
        r,g,b = colors[1], colors[2], colors[3]

        hue_img = Magick::Image.new(width, height) {|x| x.background_color = "hsl(#{r},50,50)"
                                                        x.format = 'png'}
        
        res = source.composite(hue_img, Magick::CenterGravity, Magick::HueCompositeOp)
        res = res.composite(source, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
        
        blob = res.to_blob            
        [200, {"Content-Type" => "image/png", 
           "Content-Length" => blob.length.to_s,
           "Cache-Control" => 'public, max-age=31557600'
         }, blob.to_s]
      else
        @app.call(env)
      end
    end
  end
end
