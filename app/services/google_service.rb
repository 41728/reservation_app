require 'google/apis/calendar_v3'
require 'googleauth'

class GoogleService
  Calendar = Google::Apis::CalendarV3
  SCOPE = 'https://www.googleapis.com/auth/calendar'

  def initialize(user)
    @user = user
    @service = Calendar::CalendarService.new
    @service.client_options.application_name = 'ReservationApp'
    @service.authorization = user_google_credentials
  end

  def create_google_meet_event(summary:, start_time:, end_time:)
    event = Calendar::Event.new(
      summary: summary,
      start: Calendar::EventDateTime.new(date_time: start_time.iso8601),
      end: Calendar::EventDateTime.new(date_time: end_time.iso8601),
      conference_data: Calendar::ConferenceData.new(
        create_request: Calendar::CreateConferenceRequest.new(
          request_id: SecureRandom.uuid,
          conference_solution_key: Calendar::ConferenceSolutionKey.new(type: 'hangoutsMeet')
        )
      )
    )

    created_event = @service.insert_event(
      'primary',
      event,
      conference_data_version: 1
    )
    created_event.hangout_link
  rescue => e
    Rails.logger.error "Google Meet event creation failed: #{e.message}"
    nil
  end

  private

  def user_google_credentials
    client_id = ENV['GOOGLE_CLIENT_ID']
    client_secret = ENV['GOOGLE_CLIENT_SECRET']

    auth_client = Signet::OAuth2::Client.new(
      client_id: client_id,
      client_secret: client_secret,
      token_credential_uri: 'https://oauth2.googleapis.com/token',
      access_token: @user.google_access_token,
      refresh_token: @user.google_refresh_token,
      expires_at: @user.google_token_expires_at, # トークンの期限も渡す
      scope: SCOPE
    )

    if auth_client.expired?
      # refresh_tokenがないとリフレッシュできないので例外を投げるか、処理を分ける
      raise "Refresh token missing" if @user.google_refresh_token.blank?
      
      auth_client.grant_type = 'refresh_token'
      auth_client.fetch_access_token! # これがrefresh_tokenを使ってアクセストークンを再取得

      @user.update!(
        google_access_token: auth_client.access_token,
        google_token_expires_at: auth_client.expires_at
      )
    end

    auth_client
  end

end
