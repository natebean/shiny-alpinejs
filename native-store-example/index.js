function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function updateTableData(e) {
  console.log("updateTableData");
  Alpine.store("tableData").updateData([
    {
      one: "one " + getRandomInt(100),
      two: "two " + getRandomInt(100),
    },
    {
      one: "one " + getRandomInt(100),
      two: "two " + getRandomInt(100),
    },
  ]);
}

document.addEventListener("alpine:init", () => {
  Alpine.store("tableData", {
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
    updateData(update) {
      this.data = update;
    },
  });
});
