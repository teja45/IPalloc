require 'rails_helper'

RSpec.describe NetworksController, type: :controller do
  describe "GET Show" do
    it "device details with 200 status" do
      ENV["IPALLOC_DATAPATH"] = "#{Rails.root}/track-ip-data"
      get :show, address: '1.2.3.4'
      expect(response).to have_http_status(200)
    end

    it "Error code 404" do
      ENV["IPALLOC_DATAPATH"] = "#{Rails.root}/track-ip-data"
      get :show, address: '1.2.3.14'
      expect(response).to have_http_status(404)
    end

  end

  describe "POST assign " do
    it "insert ipaddress in file 201" do
      ENV["IPALLOC_DATAPATH"] = "#{Rails.root}/track-ip-data"
      post :assign, {ip: '1.2.3.15', device: 'device4'}
      expect(response).to have_http_status(201)
    end

    it "given IP Address already assigned" do
      ENV["IPALLOC_DATAPATH"] = "#{Rails.root}/track-ip-data"
      post :assign, {ip: '1.2.3.4', device: 'device4'}
      expect(response).to have_http_status(409)
    end

    it "given IP Address not in range" do
      ENV["IPALLOC_DATAPATH"] = "#{Rails.root}/track-ip-data"
      post :assign, {ip: '1.3.2.2', device: 'device25'}
      expect(response).to have_http_status(400)
    end
  end
end
