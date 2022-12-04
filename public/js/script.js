function clean_destinations_list() {
    $("#houses_list").empty()
}

function assign_store_values(data) {
    $("#store").text(data["store"])
    $("#model").text(data["model"])
    $("#model_to_send").text(data["model"])
    $("#quantity").text(data["quantity"])
    $("#stock").text(data["stock"].toUpperCase())
}

function styled_stock_message(stock) {
    let element = document.querySelector("#stock")

    element.style.color = "white"
    if (stock == "minimum") element.style.backgroundColor = "red"
    if (stock == "medium") element.style.backgroundColor = "blue"
    if (stock == "high") element.style.backgroundColor = "green"
}

function houses_destination_list(houses) {
    var container_block

    container_block = document.querySelector("#allStores > tbody")

    if (houses != undefined && houses.length > 0) {
        houses.forEach((house) => {

            newRow = container_block.insertRow()
            newRow.insertCell().append(house[0])
            newRow.insertCell().append(house[1])
        })
    } else {
        container_block.append("ND")
    }
    $("#houses_list").show()
}

$(function () {
  console.log("Loading faye")

  var faye = new Faye.Client("http://localhost:9292/faye")
  faye.subscribe("/messages/new", function (data) {
      clean_destinations_list()
      assign_store_values(data)
      houses_destination_list(data["houses"])
      styled_stock_message(data["stock"])
  })
})
