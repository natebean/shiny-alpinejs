function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function updateTableData(e) {
  console.log("updateTableData");
  Alpine.store("tableData").updateData([
    {
      column: "one " + getRandomInt(100),
      title: "two " + getRandomInt(100),
      robot: getRandomInt(10) > 5 ? "green-robot" : "red-robot",
    },
    {
      column: "one " + getRandomInt(100),
      title: "two " + getRandomInt(100),
      robot: getRandomInt(10) > 5 ? "green-robot" : "red-robot",
    },
    {
      column: "one " + getRandomInt(100),
      title: "two " + getRandomInt(100),
      robot: getRandomInt(10) > 5 ? "green-robot" : "red-robot",
    },
  ]);
}
