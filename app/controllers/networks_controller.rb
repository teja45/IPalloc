class NetworksController < ApplicationController
  respond_to :json

  def show
    ip_device = Network.check_ip_and_return_device(params['address'])
    if ip_device.present?
      render :json => {"device" => ip_device, "ip" => params['address']}, :status => 200
    else
      render :json => {"error" => "NotFound", "ip" => params['address']}, :status => 404
    end
  end

  def assign
    cidr = NetAddr::CIDR.create('1.2.0.0/16')
    if cidr.contains?(params["ip"])
      ip_device = Network.check_ip_and_return_device(params['ip'])
      if ip_device.present?
        render :json => {"error" => "Given IP Address already assigned as '#{ip_device}'", "ip" => params['ip']}, :status => 409
      else
        Network.insert_data_into_csv(params['ip'], params['device'])
        render :json => {"ip" => params['ip'], "device" => params['device']}, :status => 201
      end
    else
      render :json => {"error" => "Given IP Address not in range.", "ip" => params['ip']}, :status => 400
    end
  end

end