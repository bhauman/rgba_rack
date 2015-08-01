require 'rmagick'

module Rack
  class Noise
    def initialize(app)
      @app = app
    end
    def call(env)
      if colors = env["PATH_INFO"].match(%r{/noise/(\d{1,3})/(\d{1,3})/(\d{1,3})/([01]\.\d+)\.png})
        r,g,b,a = colors[1], colors[2], colors[3], colors[4]
        i = Magick::Image.new(150,90) {|x| x.background_color = "rgba(#{r},#{g},#{b},#{a})"
          x.format = 'png'}
        #1.times { i = i.add_noise(Magick::GaussianNoise) }
        #6.times { i = i.add_noise(Magick::UniformNoise) }
        4.times { i = i.add_noise_channel(Magick::GaussianNoise,
                                          Magick::LuminosityChannel) }
        #1.times { i = i.add_noise_channel(Magick::GaussianNoise, Magick::SaturationChannel) }                        

        # 6.times { i = i.add_noise(Magick::GaussianNoise) }        
#        i = i.gaussian_blur(0.1)
        blob = i.to_blob            
        [200, {"Content-Type" => "image/png", 
           "Content-Length" => blob.length.to_s,
           "Cache-Control" => 'public, max-age=31557600'
         }, [blob.to_s]]
      else
        @app.call(env)
      end
    end
  end
end
