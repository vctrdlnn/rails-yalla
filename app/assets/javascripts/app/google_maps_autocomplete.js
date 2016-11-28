$(document).ready(function() {
  // Code for 'activity address'
  var activity_address = $('#activity_address').get(0);

  if (activity_address) {
    var autocomplete = new google.maps.places.Autocomplete(activity_address, { types: ['geocode'] });
    google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
    google.maps.event.addDomListener(activity_address, 'keydown', function(e) {
      if (e.keyCode == 13) {
        e.preventDefault(); // Do not submit the form on Enter.
      }
    });
  }

  // Code for 'activity establishment'
  var activity_establishment = $('#activity_establishment').get(0);

  if (activity_establishment) {
    var autocomplete = new google.maps.places.Autocomplete(activity_establishment, { types: ['establishment'] });
    google.maps.event.addListener(autocomplete, 'place_changed', onActivityPlaceChanged);
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
  $('#activity_establishment').val(components.name);
  $('#activity_city').val(components.city);
  $('#activity_google_category').val(components.type);
}


function onActivityPlaceChanged() {
  var place = this.getPlace();

  var components = getAddressComponents(place);
  $('#activity_establishment').trigger('blur').val(components.name);
  $('#activity_address').val(components.formatted_address);
  $('#activity_city').val(components.city);
  $('#activity_google_category').val(components.type);
}

function onTripPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);

  $('#trip_city').trigger('blur').val(components.city);
  $('#trip_country').val(components.country_code);
  if($('#trip_title').val() == "") {
    $('#trip_title').val("Week end in " + components.formatted_address);
  }
}

function getAddressComponents(place) {
  // If you want lat/lng, you can look at:
  // - place.geometry.location.lat()
  // - place.geometry.location.lng()

  var street_number = null;
  var route = null;
  var zip_code = null;
  var city = null;
  var type = null;
  var country_code = null;
  var name = null;
  var formatted_address = null;
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
      } else if (type == 'postal_code') {
        zip_code = component.long_name;
      } else if (type == 'locality') {
        city = component.long_name;
      } else if (type == 'country') {
        country_code = component.short_name;
        country = component.long_name
      }
    }
  }
  formatted_address = place.formatted_address
  name = place.name
  type = place.types[0]

  return {
    address: street_number == null ? route : (street_number + ' ' + route),
    zip_code: zip_code,
    city: city,
    country_code: country_code,
    country: country,
    type: type,
    name: name,
    formatted_address: formatted_address
  };
}
