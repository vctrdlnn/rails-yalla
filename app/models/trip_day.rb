# days belonging to trips to which we assign activities when sorting them out
class TripDay < ApplicationRecord
  belongs_to :trip
  has_many :activities, dependent: :destroy

  def panel_id
    self.title.downcase.gsub(' ', '_')
  end

  def static_map_url(width = 600, height = 600)
    base = "https://maps.googleapis.com/maps/api/staticmap?"
    params = "?center=#{self.trip.lat},#{self.trip.lon}&size=" + width.to_s + "x" + height.to_s + "&maptype=roadmap&visible="
    key = "&key=" + ENV['GOOGLE_API_BROWSER_KEY']
    markers = ""
    path = "&path=color:0x0000ff70%7Cweight:3"
    sorted_activities = self.activities.where.not(lat: nil, lon: nil).sort { |x, y| x.index <=> y.index }
    sorted_activities.each do |act|
      m_color = color_code(act.main_category.color)
      markers += "&markers=color:#{m_color}%7Clabel:#{act.index.to_s}%7C#{act.lat},#{act.lon}"
      path += "%7C#{act.lat},#{act.lon}"
    end
    base + params + markers + path + key
  end

  def color_code(color_name)
    # https://coolors.co/3be280-ffde4f-ff496b-4da2f2-ff6142
    case color_name
      when "bg-nature"
        "0x3be280" # "0xCCE2D5"
      when "bg-visites"
        "0xffde4f" # "0xFFF6CE"
      when "bg-shopping"
        "0xff496b" # "0xFFD3DB"
      when "bg-fun"
        "0x4da2f2" # "0xCDE0F2"
      when "bg-food"
        "0xff6142" # "0xFFD1C8"
      when "bg-others"
        "0x575757" # "0xefefef"
     else
        "0x575757"
    end
  end
end
