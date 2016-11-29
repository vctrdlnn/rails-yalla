module TripsHelper

  def panel_id(tripday)
    tripday.title.downcase.gsub(' ', '_')
  end

end
