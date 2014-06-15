
module Hinfo

  class Service
    attr_reader :name, :signature, :protocol

    def initialize(srv_name, srv_data)
      @name = srv_name 
      @signature = srv_data['signature']
      @protocol = srv_data['protocol'].split ','
    end

  end # Hinfo::Service

end # Hinfo
