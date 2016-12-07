module ActivitiesHelper
  def activity_photo_index_path(activity)
    if activity.photo_url.nil?
      cl_image_path("city2_glimf7.jpg", width: 200, height: 150, crop: :fill)
    else
      cl_image_path(activity.photo.url(:summary))
    end
  end

  def activity_photo_index_tag(activity)
    if activity.photo_url.nil?
      cl_image_tag("city2_glimf7.jpg", width: 200, height: 150, crop: :fill)
    else
      cl_image_tag(activity.photo.url(:summary))
    end
  end
end
