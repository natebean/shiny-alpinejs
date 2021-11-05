window.addEventListener("load", function () {
  if (typeof Shiny !== "undefined") {
    Shiny.addCustomMessageHandler("alpine-update-data", updateAlpineDataStore);
    initializeAlpine();
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
    alpine_script.setAttribute("defer", true);

    document.head.appendChild(alpine_script);
  } else {
    console.error("Alpine already loaded");
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
  console.log("updateAlpineDataStore", dataPackage);
  storeName = dataPackage.name[0];
  storeData = dataPackage.data;
  Alpine.store(storeName).updateData(storeData);
}
