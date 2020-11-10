require 'rubygems'
require 'rmagick'
require './rack_rgba.rb'
require './rack_color_img.rb'
require './rack_gradient.rb'
require './rack_noise.rb'
require './rack_noise_gradient.rb'
   #require 'rack/reloader'
require 'time'
require 'digest/md5'
  # require 'rack/cache'

=begin
use Rack::Cache,
  :verbose     => true,
  :metastore   => 'file:cache/meta',
  :entitystore => 'file:cache/body'
=end

# use Rack::Reloader


use ::Rack::Rgba
use ::Rack::ColorImg
use ::Rack::Gradient
use ::Rack::Noise
use ::Rack::NoiseGradient

run lambda {|x| [200, {"Content-Type" => 'text/html'}, ["Hello"]]}
