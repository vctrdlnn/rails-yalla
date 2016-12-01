$(document).ready(function() {
  // Code for 'activity address'
  var options = {};
  if ($('#city_coordinates').text().length > 6) {
    var lat = parseFloat($('#city_coordinates').text())
    var lng = parseFloat($('#city_coordinates').text().split("|").pop())
    var latLng = new google.maps.LatLng(lat, lng);/*San Diego*/
    var radius = 100000;/*meters*/
    var circle = new google.maps.Circle({center: latLng, radius: radius});
    var defaultBounds= circle.getBounds();
    options = {
          bounds: defaultBounds
      };
  }
  var activity_address = $('#activity_address').get(0);

  if (activity_address) {
    var address_autocomplete = new google.maps.places.Autocomplete(activity_address, { options });
    google.maps.event.addListener(address_autocomplete, 'place_changed', onPlaceChanged);
    google.maps.event.addDomListener(activity_address, 'keydown', function(e) {
      if (e.keyCode == 13) {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }

  // Code for 'activity establishment'
  var activity_establishment = $('#activity_est_establishment').get(0);

  if (activity_establishment) {
    var establishment_autocomplete = new google.maps.places.Autocomplete(activity_establishment, { types: ['establishment'] });
    google.maps.event.addListener(establishment_autocomplete, 'place_changed', onActivityPlaceChanged);
    google.maps.event.addDomListener(activity_establishment, 'keydown', function(e) {
      if (e.keyCode == 13) {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }

  // Code for 'trip city'
  var trip_city = $('#trip_city').get(0);

  if (trip_city) {
    var autocomplete = new google.maps.places.Autocomplete(trip_city, { types: ['(cities)'] });
    google.maps.event.addListener(autocomplete, 'place_changed', onTripPlaceChanged);
    google.maps.event.addDomListener(trip_city, 'keydown', function(e) {
      if (e.keyCode == 13) {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }
});


function onPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);
  $('#activity_address').trigger('blur').val(components.address);
  if (city == null) {
    $('#activity_establishment').val(components.name);
  }
  $('#activity_city').val(components.city);
  $('#activity_google_category').val(components.type);
  $('#activity_google_place_identifier').val(components.place_id);
  if (def_title) {
    if($('#activity_title').val() == "") {
      $('#activity_title').val(cat_select + components.address);
    }
  }
}


function onActivityPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);

  $('#activity_est_establishment').trigger('blur').val(components.name);
  $('#activity_est_address').val(components.formatted_address);
  $('#activity_est_city').val(components.city);
  $('#activity_est_google_category').val(components.type);
  $('#activity_est_google_place_identifier').val(components.place_id);
  if (def_title) {
    if($('#activity_est_title').val() == "") {
      var categ = components.type.replace("_", " ");
      categ = categ.charAt(0).toUpperCase() + categ.slice(1)+ " at ";
      $('#activity_est_title').val(categ + components.name);
    }
    console.log("by activity")
  }
}

// Specific to "New Trips"
function onTripPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);

  $('#trip_city').trigger('blur').val(components.city);
  $('#trip_country').val(components.country_code);
  if($('#trip_title').val() == "") {
    $('#trip_title').val("Week end in " + components.city);
  }
}

function getAddressComponents(place) {
  // If you want lat/lng, you can look at:
  // - place.geometry.location.lat()
  // - place.geometry.location.lng()

  var street_number = null;
  var route = null;
  var premise = null;
  var zip_code = null;
  var city = null;
  var city_backup = null;
  var type = null;
  var country_code = null;
  var name = null;
  var formatted_address = null;
  var place_id = null;
  console.log(place);
  // debugger
  for (var i in place.address_components) {
    var component = place.address_components[i];
    for (var j in component.types) {
      var type = component.types[j];
      if (type == 'street_number') {
        street_number = component.long_name;
      } else if (type == 'route') {
        route = component.long_name;
      } else if (type == 'natural_feature' || type == 'premise') {
        premise = component.long_name;
      } else if (type == 'postal_code') {
        zip_code = component.long_name;
      } else if (type == 'locality') {
        city = component.long_name;
      } else if (type == 'administrative_area_level_3') {
        city_backup = component.long_name
      }else if (type == 'country') {
        country_code = component.short_name;
        country = component.long_name
      }
    }
  }
  formatted_address = place.formatted_address;
  name = place.name;
  type = place.types[0];
  place_id = place.place_id;
  if (city == null) {
    city = city_backup;
  };
  if (route == null) {
    route = name + ', ' + city;
  };

  return {
    address: street_number == null ? route : (street_number + ' ' + route),
    zip_code: zip_code,
    city: city,
    country_code: country_code,
    country: country,
    type: type,
    name: name,
    formatted_address: formatted_address,
    place_id: place_id
  };
}
