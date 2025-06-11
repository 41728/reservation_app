class ZoomController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  def oauth
    client_id = ENV['ZOOM_CLIENT_ID']
    redirect_uri = ENV['ZOOM_REDIRECT_URI']
    zoom_auth_url = "https://zoom.us/oauth/authorize?response_type=code&client_id=#{client_id}&redirect_uri=#{redirect_uri}"
    redirect_to zoom_auth_url, allow_other_host: true
  end

  def callback
    code = params[:code]
    uri = URI("https://zoom.us/oauth/token")
    req = Net::HTTP::Post.new(uri)
    req.basic_auth(ENV['ZOOM_CLIENT_ID'], ENV['ZOOM_CLIENT_SECRET'])
    req.set_form_data(
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: ENV['ZOOM_REDIRECT_URI']
    )

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    data = JSON.parse(res.body)

    current_user.update(
      zoom_access_token: data["access_token"],
      zoom_refresh_token: data["refresh_token"]
    )

    redirect_to user_path(current_user), notice: "Zoom連携に成功しました"
  end
end
