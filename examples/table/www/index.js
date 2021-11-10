function getRandomInt(max) {
  return Math.floor(Math.random() * max);
}

function updateTableData(e) {
  const data = Array.from(Array(10)).map((_, i) => {
    randomName = getRandomInt(100)
    return {
      column: `column ${randomName}`,
      title: `title ${randomName}`,
      robot: getRandomInt(10) > 5 ? "green-robot" : "red-robot",
      title_change: "",
      robot_change: "",
    };
  });
  Alpine.store("tableData").updateData(data);
}
