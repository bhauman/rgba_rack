require 'rubygems'
require 'rmagick'
require 'rack_rgba'
require 'rack_gradient'
require 'rack_noise'
require 'rack_noise_gradient'
require 'rack/reloader'
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
use Rack::Rgba
use Rack::Gradient
use Rack::Noise
use Rack::NoiseGradient

run lambda {|x| [200, {"Content-Type" => 'text/html'}, "Hello"]}
