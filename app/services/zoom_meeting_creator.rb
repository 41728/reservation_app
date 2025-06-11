require 'net/http'
require 'uri'
require 'json'

class ZoomMeetingCreator
  def initialize(access_token)
    @access_token = access_token
  end

  def create_meeting(user_email:, start_time:)
    user_id = "me"
    uri = URI.parse("https://api.zoom.us/v2/users/#{user_id}/meetings")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@access_token}"
    request["Content-Type"] = "application/json"

    request.body = {
      topic: "予約ミーティング",
      type: 2,
      start_time: start_time.iso8601,
      duration: 30,
      timezone: "Asia/Tokyo",
      settings: {
        join_before_host: true,
        waiting_room: false
      }
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    Rails.logger.debug "Zoom API Status: #{response.code}"
    Rails.logger.debug "Zoom API Body: #{response.body}"

    if response.code.to_i == 201
      JSON.parse(response.body)
    else
      Rails.logger.error("Zoom APIエラー: #{response.body}")
      nil
    end
  end
end
