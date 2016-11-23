
User.destroy_all
Trip.destroy_all
TripDay.destroy_all
Activity.destroy_all


user_params = {username: "victor01", email: "admin@admin.com", password: "000000", mobile: "0604590059"}
user = User.create!(user_params)

trips = [
  {
    title: "Week-end à Paris",
    description: "While the Right Bank of Paris has seen internationalism and the irrepressible rise of bobos (the Parisian form of hipsters) change its landscape in recent years, the Left Bank has been able to preserve the soul of the French capital. Walk through the Latin Quarter’s crooked cobblestone corridors or down the grand plane-tree-lined boulevards of St.-Germain-des-Prés and, more than once, you’ll think you’re inside a black-and-white Robert Doisneau photo.",
    category: "decouverte",
    city: "Paris",
    country: "France",
    user: user
  },
  {
    title: "Budapest par Glamour",
    description: "c’est à Budapest que ça se passe  Encore méconnue, Budapest attire la jeunesse européenne en quête de découvertes placées sous le signe du design et de l’art. Cette ville cosmopolite, foisonne de boutiques insolites, de petits cafés et de galeries d’art où se délasse la nouvelle scène artistique hongroise. Glamour vous fait faire le tour des lieux à ne pas manquer lors d’un week-end dans l’une des capitales les plus cool d’Europe.",
    category: "entre copines",
    city: "Budapest",
    country: "Hongrie",
    user: user
  }
]

trips.each do |t|
  trip = Trip.create!(t)
  # trip.save
end


trip_days = [
  {
    title: "Vendredi aprem", date: "42713", trip: Trip.first
  },
  {
    title: "Samedi", date: "42714", trip: Trip.first
  },
  {
    title: "Dimanche", date: "42715", trip: Trip.first
  }
]


trip_days.each do |td|
  trip_day = TripDay.create!(td)
end


some_activities = [
  {
    title: "APPETITE AWAKENER",
    description: "will prime you for the weekend’s culinary delights",
    category: "Restaurants",
    establishment: "Taste of St.-Germain", address: "", city: "Paris", index: "1", trip: Trip.first
  },
  {
    title: "Marche",
    description: "where moneyed locals scoop up their saucisson, fresh milk and seasonal produce",
    category: "Shopping",
    establishment: "Le Marché Couvert",
    address: "", city: "Paris", index: "2", trip: Trip.first, trip_day: TripDay.first
  },
  {
  title: "To the top", description: "Four elevators will whoosh you to the top (or, if you’re feeling dauntless, tackle the 1,665 steps; 17 euros and 7 euros, respectively) and by now it will be l’heure bleue, that magical time in the evening when the whole city is suffused in an ethereal light", category: "Activities", establishment: "The Eiffel Tower", address: "", city: "Paris", index: "3", trip: Trip.first, trip_day: TripDay.first
  },
  {
  title: "AVANT GARDE ART", description: "he Cartier Fondation and Fondation Henri Cartier-Bresson, which are within walking distance of each other on opposite sides of the famed Montparnasse Cemetery, are sized to offer just the right dose of the familiar and the cutting edge", category: "Museum", establishment: "Fondation Henri Cartier-Bresson", address: "", city: "Paris", index: "1", trip: Trip.first, trip_day: TripDay.first
  },
  {
  title: "LUNCH WORTH WAITING FOR", description: "On a sloping corner in St. Germain, the sliver of a restaurant is, in fact, most noticeable for the line of hungry people waiting for the first-come-first-served weekend service from the chef Yves Camdeborde, who’s often credited with starting the “bistronomy” trend currently rocking the Right Bank", category: "Restaurants", establishment: "Le Comptoir du Relais", address: "", city: "Paris", index: "2", trip: Trip.first, trip_day: TripDay.first
  },
  {
  title: "TERRACE VIEWS", description: "Snatch one of the coveted seats at Café de Flore, where figures such as Simone de Beauvoir and Picasso once sipped, puffed and pontificated, and watch the coiffed regulars come in and kiss-kiss the maître d’hôtel while harried waiters in long white aprons weave and wend, delivering trays of aperitifs", category: "Cafe", establishment: "Café de Flore", address: "172 Boulevard St. Germain, 6ème", city: "Paris", index: "3", trip: Trip.first
  },
  {
  title: "NOUVEAU COOKING", description: "Neither trendy nor nostalgic, Semilla manages the perfect balance of nouveau Parisian cooking. Opened in 2012 by the international team of Juan Sanchez and Drew Harré, the sparse but sophisticated restaurant ", category: "Restaurants", establishment: "Semilla", address: "", city: "Paris", index: "4", trip: Trip.first
  },
  {
  title: "GET FRESH", description: "It’s the onion galettes — shredded onion, potato and cheese — frying at one of the dozens of stands at the Marché Biologique Raspail", category: "Marche", establishment: "", address: "Boulevard Raspail", city: "Paris", index: "1", trip: Trip.first, trip_day: TripDay.last
  },
  {
  title: "SUNDAY STROLL", description: "No longer are the Luxembourg Gardens the only nearby spot of green where you can eat your market loot", category: "Parcs", establishment: "", address: "Luxembourg Gardens", city: "Paris", index: "", trip: Trip.first
  },
  {
  title: "Berges de seines", description: "Les Berges de Seine, a nearly 1.5-mile stretch along the Seine reserved for pedestrians, debuted in 2013, so what was once a diesel-fume-choked highway is now thronged with strolling families, joggers, bicyclists and skaters", category: "Ballades", establishment: "", address: "Berges de Seine", city: "Paris", index: "", trip: Trip.first
  },
  {
  title: "SWEET ENDING", description: "This boutique is also an 8,600-square-foot salon de thé/restaurant/lounge devoted to high-end chocolate.", category: "Shopping", establishment: "Un dimanche a paris", address: "4-6-8 Cour du Commerce Saint-André, 6ème", city: "Paris", index: "2", trip: Trip.first, trip_day: TripDay.last
  }
]


some_activities.each do |a|
  activity = Activity.create!(a)
end

