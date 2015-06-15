desc 'Import all strava activities that have a description of 400 characters or more'
namespace :strava do
  task import: :environment do
    MIN_DESCRIPTION_LENGTH = 400
    activities = []
    i = 1

    loop do
      result = STRAVA_API_CLIENT.list_athlete_activities(page: i)
      if result.present?
        activities += result
        i += 1
      else
        break
      end
    end

    activities.each do |activity|
      activity_detail = STRAVA_API_CLIENT.retrieve_an_activity(activity['id'])
      if activity_detail['description'].try(:length) || 0 > MIN_DESCRIPTION_LENGTH
        puts "Creating entry for strava activity ##{activity_detail['id']}"
        ActivityForm.new(strava_activity_id: activity_detail['id']).save
      end
    end
  end
end
