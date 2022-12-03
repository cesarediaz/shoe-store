function clean_destinations_list() {
    $("#houses_list").hide()
    $("#houses_list").empty()
}

function assign_store_values(data) {
    $("#store").text(data["store"])
    $("#model").text(data["model"])
    $("#quantity").text(data["quantity"])
    $("#stock").text(data["stock"].toUpperCase())
}

function styled_stock_message(stock) {
    let element = document.querySelector("#stock")

    element.style.color = "white"
    if (stock == "minimum") {
        element.style.backgroundColor = "red"
    }
    if (stock == "medium") {
        element.style.backgroundColor = "blue"
    }
    if (stock == "high") {
        element.style.backgroundColor = "green"
    }
}

function houses_destination_list(houses) {
    var block_to_insert
    var container_block

    container_block = document.getElementById("houses_list")
    $("#houses_list").empty()

    if (houses != undefined && houses.length > 0) {
        houses.forEach((house) => {
            block_to_insert = document.createElement("tr")
            block_to_insert.innerHTML = house

            container_block.appendChild(block_to_insert)
        })
    } else {
        container_block.append("ND")
    }
    $("#houses_list").show()
}

$(function () {
  console.log("Loading...")

  var faye = new Faye.Client("http://localhost:9292/faye")
  faye.subscribe("/messages/new", function (data) {
      console.log(data)
      clean_destinations_list()
      assign_store_values(data)
      houses_destination_list(data["houses"])
      styled_stock_message(data["stock"])
  })
})
