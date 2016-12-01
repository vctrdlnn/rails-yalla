module ActivitiesHelper
  def activity_photo_index_path(activity)
    if activity.photo_url.nil?
      cl_image_path("city2_glimf7.jpg", width: 400, height: 300, crop: :fill)
    else
      cl_image_path(activity.photo, width: 400, height: 300, crop: :fill)
    end
  end

  def activity_photo_index_tag(activity)
    if activity.photo_url.nil?
      cl_image_tag("city2_glimf7.jpg", width: 400, height: 300, crop: :fill)
    else
      cl_image_tag(activity.photo, width: 400, height: 300, crop: :fill)
    end
  end
end
