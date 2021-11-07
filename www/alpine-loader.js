window.addEventListener("load", function () {
  console.log("window:load");
  initializeAlpine();
  if (typeof Shiny !== "undefined") {
    Shiny.addCustomMessageHandler("alpine-update-data", updateAlpineDataStore);
  } else {
    console.error("No Shiny Found");
  }
});

function initializeAlpine() {
  storageNameList = htmlAlpinePrep();
  if (typeof storageNameList !== "undefined") {
    document.addEventListener("alpine:init", () => {
      initializeAlpineDataStores(storageNameList);
    });
  }
  loadAlpine();
}

$(document).on("shiny:connected", function (event) {
  console.log("shiny:connected");
});

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

function loadAlpine() {
  if (typeof Alpine === "undefined") {
    var alpine_script = document.createElement("script");
    alpine_script.setAttribute(
      "src",
      "https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"
    );
    document.head.appendChild(alpine_script);
  } else {
    console.warn("Alpine already loaded");
  }
}

function initializeAlpineDataStores(storageNameList) {
  storageNameList.forEach((storeName) => {
    Alpine.store(storeName, {
      data: [],
      updateData(update) {
        this.data = update;
      },
      sendDataToShiny() {
        console.log("sending", storeName, this.data);
        Shiny.setInputValue(storeName + "_data", JSON.stringify(this.data));
      },
    });
  });
}

function updateAlpineDataStore(dataPackage) {
  if (typeof Alpine === "undefined") {
    document.addEventListener("alpine:init", () => {
      updateADS(dataPackage.name[0], dataPackage.data);
    });
  } else {
    updateADS(dataPackage.name[0], dataPackage.data);
  }
}

function updateADS(storeName, storeData) {
  if (Alpine.store(storeName) !== undefined) {
    Alpine.store(storeName).updateData(storeData);
  } else {
    console.warn(`${storeName} not found`);
  }
}

function sendDataToShiny(storeName) {
  Alpine.store(storeName).sendDataToShiny();
}
