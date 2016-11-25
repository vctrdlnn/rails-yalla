class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def short_description(nb)
    if description.length > nb
      truncate(description, nb, elided = ' ...')
    else
      description
    end
  end

  def truncate(s, max=70, elided = ' ...')
    # TODO deplacer dans un helper/concerns ?
    s.match( /(.{1,#{max}})(?:\s|\z)/ )[1].tap do |res|
      res << elided unless res.length == s.length
    end
  end
end
