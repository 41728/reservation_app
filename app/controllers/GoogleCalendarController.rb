require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'securerandom'

class GoogleCalendarController < ApplicationController
  OOB_URI = 'http://localhost:3000/oauth2callback'
  BASE_URL = 'http://localhost:3000'
  APPLICATION_NAME = 'Rails Google Meet Integration'
  CREDENTIALS_PATH = 'credentials.json'
  TOKEN_PATH = 'token.yaml'
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

  def index
  end

  def authorize
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)

    redirect_to authorizer.get_authorization_url(
      base_url: BASE_URL,
      access_type: 'offline',
      prompt: 'consent'
    ), allow_other_host: true
  end

  def callback
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)

    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: 'default',
      code: params[:code],
      base_url: BASE_URL
    )

    redirect_to google_calendar_path, notice: '認証が完了しました！'
  end

  def create_event
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
    token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    credentials = authorizer.get_credentials('default')

    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = credentials

    home = Home.find(params[:home_id])

    event = Google::Apis::CalendarV3::Event.new(
      summary: '打ち合わせ',
      start: {
        date_time: home.start_time.in_time_zone('Asia/Tokyo').iso8601,
        time_zone: 'Asia/Tokyo'
      },
      end: {
        date_time: home.end_time.in_time_zone('Asia/Tokyo').iso8601,
        time_zone: 'Asia/Tokyo'
      },
      conference_data: {
        create_request: {
          request_id: SecureRandom.uuid
        }
      }
    )


    result = service.insert_event(
      'primary',
      event,
      conference_data_version: 1
    )

    meet_url = result.conference_data.entry_points.find { |e| e.entry_point_type == 'video' }&.uri

    home.update(google_meet_url: meet_url)
    redirect_to user_path(current_user), notice: 'Google Meet付きイベントを作成しました'
  end
end

