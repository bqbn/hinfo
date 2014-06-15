require 'sinatra/base'
require 'facter'
require 'json'
require 'yaml'
require 'hinfo/service'
require 'hinfo/utils'

module Hinfo

  class Runnable < Sinatra::Base

    before do
      # set default content type
      # see module Rack::Mime for possible mime types
      content_type :txt
    end
    
    before do
      srv_conf = {}
      [
        'conf/service.yml',
        '/etc/hinfo/service.yml', 
        "#{ENV['HOME']}/.hinfo/service.yml",
      ].each do |conf|
        srv_conf.merge!(YAML.load_file(conf)) if File.exist?(conf)
      end

      services = []
      srv_conf.keys.each do |srv_name|
        services.push Service.new(srv_name, srv_conf[srv_name])
      end

      services.each do |srv|
        Facter.add("#{srv.name}_pid") do
          confine :kernel => 'Linux'
          setcode do 
            IO.popen(['/usr/bin/pgrep', '-f', "#{srv.signature}"]) { |pgrep_io|
              pgrep_io.read.chomp
            }
          end
        end

        Facter.add("#{srv.name}_running") do
          setcode do
            Facter.value("#{srv.name}_pid") ? 'true' : 'false'
          end
        end

        Facter.add("#{srv.name}_port") do
          setcode do
            results = []
            srv.protocol.each do |pro|
              Utils.infer_binding_ip_and_port(Facter.value("#{srv.name}_pid"), pro).each do |binding|
                results.push "#{pro}://#{binding}"
              end
            end
            results.join(',')
          end
        end
      end
    end

    after do
      Facter.clear
    end

    get '/' do
      if request.accept? 'yaml'
        content_type :yaml
        Facter.to_hash.to_yaml
      elsif request.accept? 'json'
        content_type :json
        Facter.to_hash.to_json
      else
        Facter.list.sort.map do |fact_name|
          "#{fact_name}: #{Facter.value(fact_name)}\n"
        end
      end
    end

    get '/:name' do
      Facter.value(params[:name])
    end

  end # Hinfo::Runnable

end # module Hinfo
