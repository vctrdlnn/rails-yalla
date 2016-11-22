# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_params = {username: "victor01", email: "victor010101@gmail.com", password: "000000", mobile: "0604590059"}

some_activities = [
  {
    title: "APPETITE AWAKENER", description: "will prime you for the weekend’s culinary delights", category: "Restaurants", establishment: "Taste of St.-Germain", address: "", city: "Paris", index: "1", trip_id: "1", trip_day_id: "1", },
    {
      title: "Marche", description: "where moneyed locals scoop up their saucisson, fresh milk and seasonal produce", category: "Shopping", establishment: "Le Marché Couvert", address: "", city: "Paris", index: "2", trip_id: "1", trip_day_id: "1", },
      {
        title: "To the top", description: "Four elevators will whoosh you to the top (or, if you’re feeling dauntless, tackle the 1,665 steps; 17 euros and 7 euros, respectively) and by now it will be l’heure bleue, that magical time in the evening when the whole city is suffused in an ethereal light", category: "Activities", establishment: "The Eiffel Tower", address: "", city: "Paris", index: "3", trip_id: "1", trip_day_id: "1", },
        {
          title: "AVANT GARDE ART", description: "he Cartier Fondation and Fondation Henri Cartier-Bresson, which are within walking distance of each other on opposite sides of the famed Montparnasse Cemetery, are sized to offer just the right dose of the familiar and the cutting edge", category: "Museum", establishment: "Fondation Henri Cartier-Bresson", address: "", city: "Paris", index: "1", trip_id: "1", trip_day_id: "2", },
          {
            title: "LUNCH WORTH WAITING FOR", description: "On a sloping corner in St. Germain, the sliver of a restaurant is, in fact, most noticeable for the line of hungry people waiting for the first-come-first-served weekend service from the chef Yves Camdeborde, who’s often credited with starting the “bistronomy” trend currently rocking the Right Bank", category: "Restaurants", establishment: "Le Comptoir du Relais", address: "", city: "Paris", index: "2", trip_id: "1", trip_day_id: "2", },
            {
              title: "TERRACE VIEWS", description: "Snatch one of the coveted seats at Café de Flore, where figures such as Simone de Beauvoir and Picasso once sipped, puffed and pontificated, and watch the coiffed regulars come in and kiss-kiss the maître d’hôtel while harried waiters in long white aprons weave and wend, delivering trays of aperitifs", category: "Cafe", establishment: "Café de Flore", address: "172 Boulevard St. Germain, 6ème", city: "Paris", index: "3", trip_id: "1", trip_day_id: "2", },
              {
                title: "NOUVEAU COOKING", description: "Neither trendy nor nostalgic, Semilla manages the perfect balance of nouveau Parisian cooking. Opened in 2012 by the international team of Juan Sanchez and Drew Harré, the sparse but sophisticated restaurant ", category: "Restaurants", establishment: "Semilla", address: "", city: "Paris", index: "4", trip_id: "1", trip_day_id: "2", },
                {
                  title: "GET FRESH", description: "It’s the onion galettes — shredded onion, potato and cheese — frying at one of the dozens of stands at the Marché Biologique Raspail", category: "Marche", establishment: "", address: "Boulevard Raspail", city: "Paris", index: "1", trip_id: "1", trip_day_id: "3", },
                  {
                    title: "SUNDAY STROLL", description: "No longer are the Luxembourg Gardens the only nearby spot of green where you can eat your market loot", category: "Parcs", establishment: "", address: "Luxembourg Gardens", city: "Paris", index: "", trip_id: "1", trip_day_id: "", },
                    {
                      title: "Berges de seines", description: "Les Berges de Seine, a nearly 1.5-mile stretch along the Seine reserved for pedestrians, debuted in 2013, so what was once a diesel-fume-choked highway is now thronged with strolling families, joggers, bicyclists and skaters", category: "Ballades", establishment: "", address: "Berges de Seine", city: "Paris", index: "", trip_id: "1", trip_day_id: "", },
                      {
                        title: "SWEET ENDING", description: "This boutique is also an 8,600-square-foot salon de thé/restaurant/lounge devoted to high-end chocolate.", category: "Shopping", establishment: "Un dimanche a paris", address: "4-6-8 Cour du Commerce Saint-André, 6ème", city: "Paris", index: "2", trip_id: "1", trip_day_id: "3", },
                      ]


                      {
title: "Vendredi aprem", date: "42713", trip_id: "1", },
{
title: "Samedi", date: "42714", trip_id: "1", },
{
title: "Dimanche", date: "42715", trip_id: "1", },
