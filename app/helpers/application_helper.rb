module ApplicationHelper
  def dynamic_root_path
    if user_signed_in?
      authenticated_root_path
    else
      unauthenticated_root_path
    end
  end

  def concise_time_ago_in_words(from_time)
    distance_in_minutes = ((Time.now - from_time) / 60).round
    case distance_in_minutes
    when 0..1
      'Just now !'
    when 2..59
      "#{distance_in_minutes}min"
    when 60..1439
      "#{(distance_in_minutes / 60).round}h"
    when 1440..43199
      "#{(distance_in_minutes / 1440).round}d"
    else
      "#{(distance_in_minutes / 43200).round}mo"
    end
  end
end
