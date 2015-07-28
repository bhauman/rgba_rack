require 'RMagick'

module Rack
  class Gradient
    def initialize(app)
      @app = app
    end
    def call(env)
      if colors = env["PATH_INFO"].match(%r{/gradient/(\d{1,3})/(\d{1,3})/(\d{1,3})/([01]\.\d+)/(\d{1,3})/(\d{1,3})/(\d{1,3})/([01]\.\d+)/(\d{1,5})\.png})
        r1,g1,b1,a1,r2,g2,b2,a2,h = colors[1], colors[2], colors[3], colors[4], colors[5], colors[6], colors[7], colors[8],colors[9]
        i = Magick::ImageList.new.read("gradient: rgba(#{r1},#{g1},#{b1},#{a1})-rgba(#{r2},#{g2},#{b2},#{a2})") {|x| x.format = 'png'; x.size = "1x#{h}" }
        i.format = 'png'
        blob = i.to_blob
        [200, {"Content-Type" => "image/png",
           "Content-Length" => blob.length.to_s,
           "Cache-Control" => 'public, max-age=31557600' 
              }, [ blob.to_s ]
        ]
      else
        @app.call(env)
      end
    end
  end
end

