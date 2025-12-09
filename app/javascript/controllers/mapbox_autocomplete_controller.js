import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mapbox-autocomplete"
export default class extends Controller {
  static values = {
    apiKey: String
  }

  static targets = ["input"]

  connect() {
    if (!this.apiKeyValue) {
      console.error("❌ Mapbox token not found. Make sure MAPBOX_ACCESS_TOKEN is in .env");
      return;
    }

    // Set the Mapbox token
    mapboxgl.accessToken = this.apiKeyValue;

    // Create the geocoder
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "address",
      placeholder: "Search for a location...",
      mapboxgl: mapboxgl
    });



    // Inject geocoder UI inside the location input
    this.geocoder.addTo(this.element);

    this.geocoder.container.childNodes[1].classList.add("frosted-input");

    // Sync selection to your Rails input
    this.geocoder.on("result", (event) => {
      this.inputTarget.value = event.result.place_name;
    });
  }

  disconnect() {
    if (this.geocoder) this.geocoder.clear();
  }
}
