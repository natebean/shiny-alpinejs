window.addEventListener("load", function () {
  if (typeof Shiny !== "undefined") {
    Shiny.addCustomMessageHandler("alpine-initalize", loadAlpine);
  } else {
    console.error("No Shiny Found");
  }
});

function loadAlpine(message) {
  console.log("message", message);

  if (typeof message !== "undefined") {
    document.addEventListener("alpine:init", () => {
      loadAlpineDataStore(message);
    });
  }

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

function loadAlpineDataStore(dataPackage) {
  console.log(dataPackage);

  dataPackage.forEach((item) => {
    storeName = item.name[0];
    storeData = item.data;
    Alpine.store(storeName, {
      data: storeData,
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
