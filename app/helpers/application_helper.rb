module ApplicationHelper
  
  #puts an @ in front of Twitter names  
  def user_name user
    if user.provider == "twitter"
      return "@"+user.name
    else
      return user.name
    end
  end
  
end
