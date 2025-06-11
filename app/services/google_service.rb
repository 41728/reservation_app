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
    # userモデルに保存したアクセストークン・リフレッシュトークン等を使って
    # Google認証クライアントを作成し返すコード例です。

    client_id = ENV['GOOGLE_CLIENT_ID']
    client_secret = ENV['GOOGLE_CLIENT_SECRET']

    auth_client = Signet::OAuth2::Client.new(
      client_id: client_id,
      client_secret: client_secret,
      token_credential_uri: 'https://oauth2.googleapis.com/token',
      access_token: @user.google_access_token,
      refresh_token: @user.google_refresh_token,
      scope: SCOPE
    )

    # トークン期限切れならリフレッシュ
    if auth_client.expired?
      auth_client.refresh!
      # 更新したアクセストークンをDBに保存
      @user.update(google_access_token: auth_client.access_token)
    end

    auth_client
  end
end
