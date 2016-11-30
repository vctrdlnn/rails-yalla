
Category.destroy_all
User.destroy_all
Trip.destroy_all
TripDay.destroy_all
Activity.destroy_all
MainCategory.destroy_all

Cloudinary::Api.delete_resources_by_tag('posted_picture_'+ENV['CLOUDINARY_USER'])


user_params = {username: "admin", email: "admin@admin.com", password: "000000", phone: "0604590059"}
user1 = User.create!(user_params)
user1.admin = true
user1.save

user_params = {username: "victor01", email: "victor010101@gmail.com", password: "000000", phone: "0055314810"}
user2 = User.create!(user_params)

main_categories =
[
  {
    title: "Cultural",
    icon: "categories/cultural.png",
    color: "bg-visites"
  },
  {
    title: "Restaurants",
    icon: "categories/restaurants.png",
    color: "bg-food"
  },
  {
    title: "Fun",
    icon: "categories/fun.png",
    color: "bg-fun"
  },
  {
    title: "Nature",
    icon: "categories/nature.png",
    color: "bg-nature"
  },
  {
    title: "Bar & Nightlife",
    icon: "categories/bar & nightlife.png",
    color: "bg-food"
  },
  {
    title: "Others",
    icon: "categories/others.png",
    color: "bg-others"
  },
  {
    title: "Sport",
    icon: "categories/sport.png",
    color: "bg-fun"
  },
  {
    title: "Communication",
    icon: "categories/communication.png",
    color: "bg-others"
  },
  {
    title: "Best of City",
    icon: "categories/Best of City.png",
    color: "bg-visites"
  },
  {
    title: "Hotels",
    icon: "categories/hotels.png",
    color: "bg-others"
  },
  {
    title: "Kids",
    icon: "categories/kids.png",
    color: "bg-fun"
  },
  {
    title: "Outdoor",
    icon: "categories/outdoor.png",
    color: "bg-nature"
  },
  {
    title: "Shopping",
    icon: "categories/shopping.png",
    color: "bg-shopping"
  },
  {
    title: "Transportation",
    icon: "categories/transportation.png",
    color: "bg-others"
  },
  {
    title: "Visits",
    icon: "categories/visits.png",
    color: "bg-visites"
  }
]

main_categories.each do |mn|
  main = MainCategory.create!(mn)

end

categories =
[
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "cafe", title: "Cafe"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "bakery", title: "Bakery"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "grocery_or_supermarket(deprecated)", title: "Grocery Or Supermarket"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "food (deprecated)", title: "Food "},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "meal_delivery", title: "Meal Delivery"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "meal_takeaway", title: "Meal Takeaway"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "restaurant", title: "Restaurant"},
{ main_category_id: MainCategory.find_by(title:"Bar & Nightlife").id, google_title: "bar", title: "Bar"},
{ main_category_id: MainCategory.find_by(title:"Bar & Nightlife").id, google_title: "night_club", title: "Night Club"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "aquarium", title: "Aquarium"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "amusement_park", title: "Amusement Park"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "florist", title: "Florist"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "rv_park", title: "Rv Park"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "zoo", title: "Zoo"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "park", title: "Park"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "pet_store", title: "Pet Store"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "veterinary_care", title: "Veterinary Care"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "airport", title: "Airport"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "bank", title: "Bank"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "car_dealer", title: "Car Dealer"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "car_rental", title: "Car Rental"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "car_repair", title: "Car Repair"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "car_wash", title: "Car Wash"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "dentist", title: "Dentist"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "department_store", title: "Department Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "doctor", title: "Doctor"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "electrician", title: "Electrician"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "electronics_store", title: "Electronics Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "embassy", title: "Embassy"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "accounting", title: "Accounting"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "atm", title: "Atm"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "plumber", title: "Plumber"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "police", title: "Police"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "gas_station", title: "Gas Station"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "general_contractor (deprecated)", title: "General Contractor "},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "finance (deprecated)", title: "Finance "},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "fire_station", title: "Fire Station"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "hospital", title: "Hospital"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "insurance_agency", title: "Insurance Agency"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "jewelry_store", title: "Jewelry Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "laundry", title: "Laundry"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "lawyer", title: "Lawyer"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "library", title: "Library"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "liquor_store", title: "Liquor Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "local_government_office", title: "Local Government Office"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "locksmith", title: "Locksmith"},
{ main_category_id: MainCategory.find_by(title:"Hotels").id, google_title: "lodging", title: "Lodging"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "cemetery", title: "Cemetery"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "church", title: "Church"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "city_hall", title: "City Hall"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "clothing_store", title: "Clothing Store"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "convenience_store", title: "Convenience Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "courthouse", title: "Courthouse"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "establishment (deprecated)", title: "Establishment "},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "beauty_salon", title: "Beauty Salon"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "hair_care", title: "Hair Care"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "hardware_store", title: "Hardware Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "health (deprecated)", title: "Health "},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "hindu_temple", title: "Hindu Temple"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "home_goods_store", title: "Home Goods Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "book_store", title: "Book Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "bus_station", title: "Bus Station"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "funeral_home", title: "Funeral Home"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "furniture_store", title: "Furniture Store"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "mosque", title: "Mosque"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "moving_company", title: "Moving Company"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "painter", title: "Painter"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "pharmacy", title: "Pharmacy"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "physiotherapist", title: "Physiotherapist"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "place_of_worship (deprecated)", title: "Place Of Worship "},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "post_office", title: "Post Office"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "real_estate_agency", title: "Real Estate Agency"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "roofing_contractor", title: "Roofing Contractor"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "parking", title: "Parking"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "school", title: "School"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "shoe_store", title: "Shoe Store"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "shopping_mall", title: "Shopping Mall"},
{ main_category_id: MainCategory.find_by(title:"Sport").id, google_title: "stadium", title: "Stadium"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "storage", title: "Storage"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "store", title: "Store"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "subway_station", title: "Subway Station"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "synagogue", title: "Synagogue"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "taxi_stand", title: "Taxi Stand"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "train_station", title: "Train Station"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "transit_station", title: "Transit Station"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "travel_agency", title: "Travel Agency"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "university", title: "University"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "casino", title: "Casino"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "bowling_alley", title: "Bowling Alley"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "campground", title: "Campground"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "spa", title: "Spa"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "movie_rental", title: "Movie Rental"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "movie_theater", title: "Movie Theater"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "art_gallery", title: "Art Gallery"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "museum", title: "Museum"},
{ main_category_id: MainCategory.find_by(title:"Sport").id, google_title: "bicycle_store", title: "Bicycle Store"},
{ main_category_id: MainCategory.find_by(title:"Sport").id, google_title: "gym", title: "Gym"}
]

categories.each  do |c|
  cat = Category.create!(c)
end


trips = [
  {
    title: "Week-end à Paris",
    description: "While the Right Bank of Paris has seen internationalism and the irrepressible rise of bobos (the Parisian form of hipsters) change its landscape in recent years, the Left Bank has been able to preserve the soul of the French capital. Walk through the Latin Quarter’s crooked cobblestone corridors or down the grand plane-tree-lined boulevards of St.-Germain-des-Prés and, more than once, you’ll think you’re inside a black-and-white Robert Doisneau photo.",
    category: "Discovery",
    city: "Paris",
    country: "France",
    user: user2
    # remote_photo_url: "v1480436546/mkkfhhy5do6ol9a1elcb.jpg"
  },
  {
    title: "Budapest par Glamour",
    description: "c’est à Budapest que ça se passe  Encore méconnue, Budapest attire la jeunesse européenne en quête de découvertes placées sous le signe du design et de l’art. Cette ville cosmopolite, foisonne de boutiques insolites, de petits cafés et de galeries d’art où se délasse la nouvelle scène artistique hongroise. Glamour vous fait faire le tour des lieux à ne pas manquer lors d’un week-end dans l’une des capitales les plus cool d’Europe.",
    category: "Friends",
    city: "Budapest",
    country: "Hongrie",
    user: user1
    # remote_photo_url: "v1480436465/w4wtv2a5jk8oi3mgaybq.jpg"
  },
  {
    title: "Weed-end à Amsterdam",
    description: "c’est à Amsterdam et ca va etre romantique!",
    category: "Lovers",
    city: "Amsterdam",
    country: "Netherlands",
    user: user1
    # remote_photo_url: "v1480436352/nif1xktixeejrdpfhdfe.jpg"
  },
  {
    title: "Weed-end à Londres",
    description: "On va visiter Londres, rejoignez-nous!",
    category: "Cultural",
    city: "London",
    country: "UK",
    user: user2
    # remote_photo_url: "v1480436623/z0oslnoed0tjqdozzrtq.jpg"
  },
  {
    title: "Weed-end à Berlin",
    description: "On part a Berlin et c'est juste genial",
    category: "Friends",
    city: "Berlin",
    country: "Germany",
    user: user2
    # remote_photo_url: "v1480434094/o1bfgj8xgjvydy2aj7pn.jpg"
  }
]

trip_photo = Cloudinary::Api.resources_by_tag('city', :max_results => 20 )

trips.each_with_index do |t, i|
  trip = Trip.create!(t)
  random_photo = trip_photo['resources'][i]['url']
  trip.remote_photo_url = random_photo
  trip.save
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
    main_category: MainCategory.all.sample,
    establishment: "Taste of St.-Germain",
    address: "8 rue du Cherche-Midi, 75006, Paris",
    city: "Paris",
    index: "1",
    trip: Trip.first
  },
  {
    title: "Marche",
    description: "where moneyed locals scoop up their saucisson, fresh milk and seasonal produce",
    main_category: MainCategory.all.sample,
    establishment: "Le Marché Couvert",
    address: "4-6 Rue Lobineau, Paris",
    city: "Paris",
    index: "2",
    trip: Trip.first,
    trip_day: TripDay.first
  },
  {
  title: "To the top",
  description: "Four elevators will whoosh you to the top (or, if you’re feeling dauntless, tackle the 1,665 steps; 17 euros and 7 euros, respectively) and by now it will be l’heure bleue, that magical time in the evening when the whole city is suffused in an ethereal light",
  main_category: MainCategory.all.sample,
  establishment: "The Eiffel Tower",
  address: "Champ de Mars, 5 Avenue Anatole France, 75007, Paris",
  city: "Paris",
  index: "3",
  trip: Trip.first,
  trip_day: TripDay.first
  },
  {
  title: "AVANT GARDE ART",
  description: "he Cartier Fondation and Fondation Henri Cartier-Bresson, which are within walking distance of each other on opposite sides of the famed Montparnasse Cemetery, are sized to offer just the right dose of the familiar and the cutting edge",
  main_category: MainCategory.all.sample,
  establishment: "Fondation Henri Cartier-Bresson",
  address: "2 Impasse Lebouis, 75014, Paris",
  city: "Paris",
  index: "1",
  trip: Trip.first,
  trip_day: TripDay.first
  },
  {
  title: "LUNCH WORTH WAITING FOR",
  description: "On a sloping corner in St. Germain, the sliver of a restaurant is, in fact, most noticeable for the line of hungry people waiting for the first-come-first-served weekend service from the chef Yves Camdeborde, who’s often credited with starting the “bistronomy” trend currently rocking the Right Bank",
  main_category: MainCategory.all.sample,
  establishment: "Le Comptoir du Relais",
  address: "5 Carrefour de l'Odéon, Paris",
  city: "Paris",
  index: "2",
  trip: Trip.first,
  trip_day: TripDay.first
  },
  {
  title: "TERRACE VIEWS",
  description: "Snatch one of the coveted seats at Café de Flore, where figures such as Simone de Beauvoir and Picasso once sipped, puffed and pontificated, and watch the coiffed regulars come in and kiss-kiss the maître d’hôtel while harried waiters in long white aprons weave and wend, delivering trays of aperitifs",
  main_category: MainCategory.all.sample,
  establishment: "Café de Flore",
  address: "172 Boulevard St. Germain, 75006, Paris",
  city: "Paris",
  index: "3",
  trip: Trip.first
  },
  {
  title: "NOUVEAU COOKING",
  description: "Neither trendy nor nostalgic, Semilla manages the perfect balance of nouveau Parisian cooking. Opened in 2012 by the international team of Juan Sanchez and Drew Harré, the sparse but sophisticated restaurant ",
  main_category: MainCategory.all.sample,
  establishment: "Semilla",
  address: "54 rue de Seine, 75006, Paris",
  city: "Paris",
  index: "4",
  trip: Trip.first
  },
  {
  title: "GET FRESH",
  description: "It’s the onion galettes — shredded onion, potato and cheese — frying at one of the dozens of stands at the Marché Biologique Raspail",
  main_category: MainCategory.all.sample,
  establishment: "",
  address: "Boulevard Raspail, Paris",
  city: "Paris",
  index: "1",
  trip: Trip.first,
  trip_day: TripDay.last
  },
  {
  title: "SUNDAY STROLL",
  description: "No longer are the Luxembourg Gardens the only nearby spot of green where you can eat your market loot",
  main_category: MainCategory.all.sample,
  establishment: "",
  address: "Luxembourg Gardens, Paris",
  city: "Paris",
  index: "1",
  trip: Trip.first
  },
  {
  title: "Berges de seines",
  description: "Les Berges de Seine, a nearly 1.5-mile stretch along the Seine reserved for pedestrians, debuted in 2013, so what was once a diesel-fume-choked highway is now thronged with strolling families, joggers, bicyclists and skaters",
  main_category: MainCategory.all.sample,
  establishment: "",
  address: "Berges de Seine, Paris",
  city: "Paris",
  index: "1",
  trip: Trip.first
  },
  {
  title: "SWEET ENDING",
  description: "This boutique is also an 8,600-square-foot salon de thé/restaurant/lounge devoted to high-end chocolate.",
  main_category: MainCategory.all.sample,
  establishment: "Un dimanche a paris",
  address: "4-6-8 Cour du Commerce Saint-André, 75006, Paris",
  city: "Paris",
  index: "2",
  trip: Trip.first,
  trip_day: TripDay.last
  }
]


some_activities.each do |a|
  activity = Activity.create!(a)
end

