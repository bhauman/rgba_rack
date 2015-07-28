require 'RMagick'

module Rack
  class Rgba
    def initialize(app)
      @app = app
    end
    def call(env)
      if colors = env["PATH_INFO"].match(%r{/(rgba|hsla)/(\d{1,3})/(\d{1,3})/(\d{1,3})/([01]\.\d+)\.png})
        r_or_h,r,g,b,a = colors[1], colors[2], colors[3], colors[4], colors[5]
        i = Magick::Image.new(1,1) {|x| x.background_color = "#{r_or_h}(#{r},#{g},#{b},#{a})"
          x.format = 'png'}
        blob = i.to_blob            
        [200, {"Content-Type" => "image/png", 
           "Content-Length" => blob.length.to_s,
           "Cache-Control" => 'public, max-age=31557600'
         }, [ blob.to_s ]]
      else
        @app.call(env)
      end
    end
  end
end

