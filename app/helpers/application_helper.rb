module ApplicationHelper
  def dynamic_root_path
    if user_signed_in?
      authenticated_root_path
    else
      unauthenticated_root_path
    end
  end
end
