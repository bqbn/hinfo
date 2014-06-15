
module Hinfo

  module Utils

    # For example, "0100007F" becomes "127.0.0.1".
    def self.reversed_quad_to_ip(reversed_quad)
      ip = []
      4.times do |i|
        ip.push(reversed_quad[2*i, 2].hex)
      end
      ip.reverse.join('.')
    end

    def self.infer_binding_ip_and_port(pid, prot='tcp')
      return [] if pid.nil?
      return [] unless ['tcp', 'udp'].include? prot

      # first, find all the sockets opened by pid.
      sockets = []
      Dir.glob("/proc/#{pid}/fd/*") do |fname|
        if File.readlink(fname).match(/socket:\[(?<inode>\d+)\]/)
          sockets.push(Regexp.last_match[:inode])
        end
      end

      # next, use the socket inode number as the key to search 
      # "/proc/net/{tcp,udp}" file to find the port(s) opened by pid.
      bindings = []
      IO.readlines("/proc/net/#{prot}").each do |line|
        if sockets.include? line.split[9]
          bindings.push line
        end
      end

      results = []
      bindings.each do |line|
        reversed_quad, port = line.split[1].split(':')
        next if reversed_quad.nil? || port.nil?
        results.push [reversed_quad_to_ip(reversed_quad), port.hex].join(':')
      end
      return results
    end

  end # module Utils

end # module Hinfo

