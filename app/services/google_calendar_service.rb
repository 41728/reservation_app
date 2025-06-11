require 'google/apis/calendar_v3'

class GoogleCalendarService
  Calendar = Google::Apis::CalendarV3
  attr_reader :service

  def initialize(access_token)
    @service = Calendar::CalendarService.new
    @service.authorization = access_token
  end

  def create_event(summary:, start_time:, end_time:)
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

    created_event = @service.insert_event('primary', event, conference_data_version: 1)
    meet_url = created_event.conference_data.entry_points.find { |e| e.entry_point_type == 'video' }&.uri
    meet_url
  end
end
