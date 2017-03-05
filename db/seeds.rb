
# Category.destroy_all
# User.destroy_all
# Trip.destroy_all
# TripDay.destroy_all
# Activity.destroy_all
# MainCategory.destroy_all

# Cloudinary::Api.delete_resources_by_tag('posted_picture_'+ENV['CLOUDINARY_USER'])


user_params = {username: "admin", email: "contact@yala-app.com", password: "000000", phone: "0604590059"}
user1 = User.create!(user_params)
user1.admin = true
user1.save

user_params = {username: "victor01", email: "victor010101@gmail.com", password: "000000", phone: "0055314810"}
user2 = User.create!(user_params)

user_params = {username: "guilaine", email: "gugu@gmail.com", password: "000000", phone: "0056714810"}
user3 = User.create!(user_params)

user_params = {username: "del", email: "del.del@gmail.com", password: "000000", phone: "0056714810"}
user4 = User.create!(user_params)

main_categories =
[
  {
    title: "Cultural",
    icon: "categories/cultural.png",
    color: "bg-visites"
  },
  {
    title: "Visits",
    icon: "categories/visits.png",
    color: "bg-visites"
  },
  {
    title: "Restaurants",
    icon: "categories/restaurants.png",
    color: "bg-food"
  },
  {
    title: "Bar & Nightlife",
    icon: "categories/bar & nightlife.png",
    color: "bg-food"
  },
  {
    title: "Shopping",
    icon: "categories/shopping.png",
    color: "bg-shopping"
  },
  {
    title: "Nature",
    icon: "categories/nature.png",
    color: "bg-nature"
  },
  {
    title: "Outdoor",
    icon: "categories/outdoor.png",
    color: "bg-nature"
  },
  {
    title: "Sport",
    icon: "categories/sport.png",
    color: "bg-fun"
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
    title: "Transportation",
    icon: "categories/transportation.png",
    color: "bg-others"
  },
  {
    title: "Fun",
    icon: "categories/fun.png",
    color: "bg-fun"
  },
  {
    title: "Others",
    icon: "categories/others.png",
    color: "bg-others"
  }
  # {
  #   title: "Communication",
  #   icon: "categories/communication.png",
  #   color: "bg-others"
  # },
  # {
  #   title: "Best of City",
  #   icon: "categories/Best of City.png",
  #   color: "bg-visites"
  # },
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
    user: user2,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480592374/paris_nfibly.jpg"
  },
  {
    title: "Budapest par Glamour",
    description: "c’est à Budapest que ça se passe  Encore méconnue, Budapest attire la jeunesse européenne en quête de découvertes placées sous le signe du design et de l’art. Cette ville cosmopolite, foisonne de boutiques insolites, de petits cafés et de galeries d’art où se délasse la nouvelle scène artistique hongroise. Glamour vous fait faire le tour des lieux à ne pas manquer lors d’un week-end dans l’une des capitales les plus cool d’Europe.",
    category: "Friends",
    city: "Budapest",
    country: "Hongrie",
    user: user4,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480592744/budapest_hm3qvp.jpg"
  },
  {
    title: "Weed-end à Amsterdam",
    description: "c’est à Amsterdam et ca va etre romantique!",
    category: "Lovers",
    city: "Amsterdam",
    country: "Netherlands",
    user: user2,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480600016/amsterdam_ornexg.jpg"
  },
  {
    title: "Weed-end à Londres",
    description: "On va visiter Londres, rejoignez-nous!",
    category: "Cultural",
    city: "London",
    country: "UK",
    user: user3,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480592906/london_geyl3z.jpg"
  },
  {
    title: "Weed-end à Berlin",
    description: "On part a Berlin et c'est juste genial",
    category: "Friends",
    city: "Berlin",
    country: "Germany",
    user: user3,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480600112/berlin_wizlvq.jpg"
  },
  {
    title: "Beautiful Florence",
    description: "Known for its rich history, Florence is a destination for those seeking vibrant culinary, artistic and musical experiences",
    category: "Family",
    city: "Florence",
    country: "Italy",
    user: user3,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480593549/florence_lowwcx.jpg"
  },
  {
    title: "Business in Dubai",
    description: "Dubai has emerged as an ethnically diverse metropolis where the world’s populations mingle in markets, galleries and international restaurants, both humble and high-end",
    category: "Business",
    city: "Dubai",
    country: "UAE",
    user: user4,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480594101/dubai_cz0qmg.jpg"
  },
  {
    title: "Best bachelor in Lille",
    description: "Lille is the only city in France where beer versus wine is the drink of choice",
    category: "Bachelor",
    city: "Lille",
    country: "France",
    user: user2,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480594424/lille_cmw6kj.jpg"
  },
  {
    title: "Love Vancouver",
    description: "An abundance of outdoor options — whether it is hiking or biking in Stanley Park, kayaking in False Creek or skiing on nearby Grouse Mountain — only adds to the appeal. The city doesn’t take its natural gifts for granted; in recent years it has become so eco-friendly that some stores don’t even offer plastic bags. With its multitude of immigrant communities and northwest Canadian culture of extreme friendliness, Vancouver feels just different enough to be intriguingly foreign but familiar enough to be easily conquered in a weekend.",
    category: "Lovers",
    city: "Vancouver",
    country: "Canada",
    user: user3,
    photo: "http://res.cloudinary.com/drvdcbpjf/image/upload/v1480595370/vancouver_ndchwa.jpg"
  }
]

trip_days = [
  {
    title: "Vendredi"
  },
  {
    title: "Samedi"
  },
  {
    title: "Dimanche"
  }
]

trips.each_with_index do |t, i|
  trip = Trip.create!(t)
  trip.remote_photo_url = t[:photo]
  trip.save
  trip_days.each do |td|
    trip.trip_days.build(td)
    trip.save
  end
end

activities_paris = [
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

activities_amsterdam = [
  {
  title: "STYLE UPGRADE",
  description: "Gathershop is a serene space opened in late 2014 that’s filled with beautiful art, clothing and more ",
  main_category: MainCategory.all.sample,
  establishment: "Gathershop",
  address: "Hannie Dankbaarpassage 19, 1053 RT Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  },
  {
  title: "PHOTO FIX",
  description: "Dutch painters of the 17th century are renowned for their mastery of light, a skill that is now celebrated in a more modern medium at Fotografiemuseum Amsterdam",
  main_category: MainCategory.all.sample,
  establishment: "Foam",
  address: "Keizersgracht 609, 1017 DS Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  },
  {
  title: "FAR EAST FLAVORS",
  description: "At Terpentijn, which opened last May, join groups of after-work Amsterdammers catching up over dishes like Donut Duck",
  main_category: MainCategory.all.sample,
  establishment: "Terpentijn",
  address: "Rokin 103, 1012 KM Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  },
  {
  title: "DE PIJP DRINKS",
  description: "At the natural-wine bar Glouglou, the atmosphere is gezellig (untranslatably cozy) with dark wood walls, elegant Jugendstil-esque windows, and wooden tables at which to sip a glass of sparkling pét-nat.",
  main_category: MainCategory.all.sample,
  establishment: "Glouglou",
  address: "Tweede van der Helststraat 3, 1073 AE Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  },
  {
  title: "MORNING ROAST",
  description: "Of the city’s many new third-wave coffee specialists, this is the finest. Baristas pull perfect espressos, accompanied by tasting notes for your beans, amid an eminently Instagrammable interior — wood-plank bar, hanging plants and parquet-wood benches.",
  main_category: MainCategory.all.sample,
  establishment: "Bocca Coffee",
  address: "Kerkstraat 96HS, 1017 GP Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  },
  {
  title: "HOME GROWN",
  description: "Tulips aren’t the only things growing in the Netherlands. For proof, follow locals to Boerenmarkt, an organic weekly market on Noordermarkt",
  main_category: MainCategory.all.sample,
  establishment: "Boerenmarkt",
  address: "Noordermarkt, 1015 NA Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  },
  {
  title: "SUPERIOR INTERIORS",
  description: "At Neef Louis Design, enormous warehouses are packed to the rafters with everything from midcentury chairs and industrial light fixtures to giant spotlights for your next film shoot.",
  main_category: MainCategory.all.sample,
  establishment: "Neef Louis Design",
  address: "Papaverweg 46, 1032 KJ Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  },
  {
  title: "FOOD HALL FAME",
  description: "Foodhallen opened in a former tram depot in 2014 with about two dozen stalls, many occupied by well-known local businesses.",
  main_category: MainCategory.all.sample,
  establishment: "Foodhallen",
  address: "Bellamyplein 51, 1053 AT Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  },
  {
  title: "WALL WORKS",
  description: "Bright Side Gallery, housed in a former garage looking over the canal, features rotating exhibitions like a recent solo show of somber paintings from the up-and-coming Dutch artist Wouter Nijland.",
  main_category: MainCategory.all.sample,
  establishment: "Bright Side Gallery",
  address: "Prinsengracht 737HS, 1017 JX Amsterdam, Netherlands",
  city: "Amsterdam",
  index: "1",
  }
]

activities_paris.each do |a|
  activity = Trip.find_by(city: "Paris").activities.build(a)
  activity.save
end


activities_amsterdam.each do |a|
  activity = Trip.find_by(city: "Amsterdam").activities.build(a)
  activity.save
end

# some_activities.each do |a|
#   activity = Activity.create!(a)
# end

