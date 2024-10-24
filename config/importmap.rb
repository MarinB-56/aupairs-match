# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.5/lib/assets/compiled/rails-ujs.js"


# Pin all controllers from the app/javascript/controllers directory
pin_all_from "app/javascript/controllers", under: "controllers"

# Bootstrap and Popper.js
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true

# jQuery
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js"

# Bootstrap Multiselect via CDN
pin "bootstrap-multiselect", to: "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.15/js/bootstrap-multiselect.min.js"

# Bootstrap Select via CDN
pin "bootstrap-select", to: "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.14.0-beta3/js/bootstrap-select.min.js"

# Mapbox
pin "mapbox-gl" # @3.7.0
pin "process" # @2.1.0
