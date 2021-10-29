function sendMessageToShiny(message) {
  if (typeof Shiny !== "undefined") {
    console.log("Message to Shiny");
    console.log("message", message);
    Shiny.setInputValue("first_input", "Hi from JS");
  } else {
    console.log("Shiny disconnected");
  }
}

function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function updateTableData(e) {
  let event = new CustomEvent("data-refresh", {
    detail: {
      tableData: {
        columns: ["one", "two"],
        data: [
          {
            one: "one " + getRandomInt(100),
            two: "two " + getRandomInt(100),
          },
          {
            one: "one " + getRandomInt(100),
            two: "two " + getRandomInt(100),
          },
        ],
      },
    },
  });
  window.dispatchEvent(event);
}

document.addEventListener("alpine:init", () => {
  // Alpine.data("tableTest", () => ({
  //   tableData: {
  //     columns: [],
  //     data: [],
  //   },
  // }));
});

window.addEventListener("load", function () {
  // window.addEventListener("data-refresh", (e) => {
  //   console.log("hit");
  //   console.log(e);
  // });

  if (typeof Shiny !== "undefined") {
    Shiny.addCustomMessageHandler("message-from-shiny", function (message) {
      console.log(message);
      let event = new CustomEvent("message-from-shiny", {
        detail: {
          message: message,
        },
      });
      window.dispatchEvent(event);
    });
  } else {
    var shinyEvent = new CustomEvent("shiny-live", {
      detail: {
        status: false,
      },
    });
    window.dispatchEvent(shinyEvent);
  }
});
