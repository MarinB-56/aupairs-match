import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl' // Don't forget this!

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    console.log();

    new mapboxgl.Marker()
        .setLngLat([this.markersValue[0].lng, this.markersValue[0].lat])
        .addTo(this.map)

    // this.markersValue.forEach((marker) => {
    //   new mapboxgl.Marker()
    //     .setLngLat([ marker.lng, marker.lat ])
    //     .addTo(this.map)
    // })

    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 5, duration: 0 })
  }

}
