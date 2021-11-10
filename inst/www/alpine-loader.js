/**
 * On Window load event, register event for getting data from Shiny
 */
window.addEventListener("load", function () {
  initializeAlpine();
  if (typeof Shiny !== "undefined") {
    Shiny.addCustomMessageHandler("shiny-alpine:update-data", updateAlpineDataStore);
  } else {
    console.error("No Shiny Found");
  }
});

/**
 * Get ready to start Alpine
 *
 * Data stores needs to be created during the 'apline:init' event
 * before Alpine looks for x-data attributes
 *
 */
function initializeAlpine() {
  storageNameList = htmlAlpinePrep();
  if (typeof storageNameList !== "undefined") {
    document.addEventListener("alpine:init", () => {
      initializeAlpineDataStores(storageNameList);
    });
  }
  loadAlpine();
}

/**
 * Update x-shiny-data attribute to x-data for Alpine.
 * Return list of Shiny data stores names we will create and manage
 *
 * @returns list of data stores that are 'connected' to Shiny
 */
function htmlAlpinePrep() {
  var storageNameList = [];
  shinyDataNodes = document.querySelectorAll("[x-shiny-data]");

  shinyDataNodes.forEach((node) => {
    storageName = node.getAttribute("x-shiny-data");
    node.removeAttribute("x-shiny-data");
    node.setAttribute("x-data", "$store." + storageName);
    storageNameList.push(storageName);
  });

  return storageNameList;
}

/**
 * We need to load Alpine after data stores are initialized
 * so we need to dynamically add in Alpine with ready
 */
function loadAlpine() {
  if (typeof Alpine === "undefined") {
    var alpine_script = document.createElement("script");
    alpine_script.setAttribute(
      "src",
      "https://unpkg.com/alpinejs@3.5.1/dist/cdn.min.js"
    );
    document.head.appendChild(alpine_script);
  } else {
    console.warn("Alpine already loaded");
  }
}

/**
 * Register and initailize data stores in Alpine
 * Using a standard a schema
 * {
 *   data: object,
 *   updateData(update): function for data updates external to Alpine.  Mainly Shiny
 *   sendDataToShiny: function to send all of the data object back to Shiny.  Will be an output${storeName}_data event in Shiny
 * }
 *
 * @param {Array<String>} storageNameList  An array of strings for data store names, coming from x-shiny-data attributes
 */
function initializeAlpineDataStores(storageNameList) {
  storageNameList.forEach((storeName) => {
    Alpine.store(storeName, {
      data: [],
      updateData(update) {
        this.data = update;
      },
      sendDataToShiny() {
        Shiny.setInputValue(storeName + "_data", JSON.stringify(this.data));
      },
    });
  });
}

/**
 * Callback function for messages from Shiny
 * Updates Alpine stores based on name
 * If Alpine isn't available yet then add update to 'apline:init' event
 *
 * @param {{name: Array, data: Obect}} dataPackage
 */
function updateAlpineDataStore(dataPackage) {
  if (typeof Alpine === "undefined") {
    document.addEventListener("alpine:init", () => {
      updateADS(dataPackage.name[0], dataPackage.data);
    });
  } else {
    updateADS(dataPackage.name[0], dataPackage.data);
  }
}

/**
 *
 *  Helper function for updating data in stores
 *
 * @param {String} storeName
 * @param {Object} storeData
 */
function updateADS(storeName, storeData) {
  if (Alpine.store(storeName) !== undefined) {
    Alpine.store(storeName).updateData(storeData);
  } else {
    console.warn(`${storeName} not found`);
  }
}

/**
 * A small abstraction function to avoid store syntax in Shiny
 *
 * @param {string} storeName
 */
function sendDataToShiny(storeName) {
  Alpine.store(storeName).sendDataToShiny();
}
