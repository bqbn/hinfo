require 'sinatra/base'
require 'optparse'

module Hinfo

  class Runnable < Sinatra::Base

#    return unless __FILE__ == $0

    lib = File.expand_path("#{File.dirname(__FILE__)}/..")
    $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include? lib
    require 'hinfo'

    OptionParser.new { |op|
      op.on('-p port', "set the port (default is #{port})") { |val| set :port, Integer(val) }
      op.on('-o addr', "set the h (default is #{bind})") { |val| set :bind, val }
      op.on('-e env', "set the environment (default is #{environment})") { |val| set :environment, val.to_sym }
    }.parse!(ARGV.dup)
    
    run!

  end # Hinfo::Runnable

end # module Hinfo
