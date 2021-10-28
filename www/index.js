function sendMessage(message) {
  console.log("Button Pressed");
  console.log("message", message);
  if (typeof Shiny !== "undefined") {
    Shiny.setInputValue("first_input", "Hi from JS");
  }
}

document.addEventListener("alpine:init", () => {
  Alpine.data("index", () => ({
    value: "index Data Object",
    includeValue: "Alpine + Shiny + Include",
  }));

  Alpine.data("tableTest", () => ({
    data: [
      { one: "one1", two: "two1" },
      { one: "one2", two: "two2" },
    ],
  }));

  if (typeof Shiny !== "undefined") {
    Shiny.addCustomMessageHandler(
      "first-message-from-shiny",
      function (message) {
        console.log(message);
        let event = new CustomEvent("first-message", {
          detail: {
            message: message,
          },
        });
        window.dispatchEvent(event);
      }
    );
  }
});
