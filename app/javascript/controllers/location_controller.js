import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl';

export default class extends Controller {
  static targets = ["locationInput", "map"]

  connect() {
    console.log("Stimulus controller connected");

    const mapboxAccessToken = document.querySelector('meta[name="mapbox-access-token"]').content;

    if (!mapboxAccessToken) {
      console.error("Mapbox access token not found!");
      return;
    }

    mapboxgl.accessToken = mapboxAccessToken;

    // Initialiser la carte avec la localisation existante
    this.initializeMap();
    this.setupAutocomplete();
    this.initializeMapWithLocation();
  }

  initializeMap() {
    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/mapbox/streets-v11',
      center: [0, 0], // Coordonnées par défaut
      zoom: 2,

      // Désactiver les interactions utilisateur sur la carte
      dragPan: false,          // Désactiver le déplacement de la carte
      scrollZoom: false,       // Désactiver le zoom avec la molette de la souris
      doubleClickZoom: false,  // Désactiver le zoom avec un double-clic
      dragRotate: false,       // Désactiver la rotation de la carte
      keyboard: false,         // Désactiver les interactions via le clavier
      touchZoomRotate: false   // Désactiver les interactions tactiles pour le zoom et la rotation
    });

    this.marker = new mapboxgl.Marker()
      .setLngLat([0, 0])
      .addTo(this.map);

    this.map.getCanvas().style.cursor = 'default';
  }

  setupAutocomplete() {
    const locationInput = this.locationInputTarget;

    locationInput.addEventListener('input', (event) => {
      const query = event.target.value;
      console.log("User input:", query);

      if (query.length > 2) {
        fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${query}.json?access_token=${mapboxgl.accessToken}`)
          .then(response => response.json())
          .then(data => {
            if (data.features.length > 0) {
              const coordinates = data.features[0].geometry.coordinates;
              this.map.flyTo({ center: coordinates, zoom: 12 });
              this.marker.setLngLat(coordinates);
            }
          })
          .catch(error => console.error("Error fetching Mapbox data:", error));
      }
    });
  }

  // Initialiser la carte avec la localisation de l'utilisateur
  initializeMapWithLocation() {
    const location = this.locationInputTarget.value;

    if (location) {
      fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(location)}.json?access_token=${mapboxgl.accessToken}`)
        .then(response => response.json())
        .then(data => {
          if (data.features.length > 0) {
            const coordinates = data.features[0].geometry.coordinates;
            this.map.flyTo({ center: coordinates, zoom: 12 });
            this.marker.setLngLat(coordinates);
            console.log("Map initialized with user location:", location);
          }
        })
        .catch(error => console.error("Error fetching Mapbox data for user location:", error));
    } else {
      console.log("No initial location found for user.");
    }
  }
}
