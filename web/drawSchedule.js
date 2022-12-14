function drawSchedule1(jsonOutput) {
    console.log("JSON:", jsonOutput);
    let colorMap = new Map();

    let table = document.getElementById("scheduleTable");
    table.innerHTML = "";

    let costLabel = document.getElementById("solutionCost");
    costLabel.innerHTML = "Solution found with cost: " + (jsonOutput["cost"] - 1);

    let timeLabel = document.getElementById("computationTime");
    timeLabel.innerHTML = "Solution computed in: " + computationTime + " ms";

    let row = table.insertRow(0);
    row.insertCell(0);
    for (j = 0; j < jsonOutput["cost"]-1; j++) {
        let cell = row.insertCell(j + 1);
        cell.innerHTML = (j + 1).toString();
        cell.height = 23;
        cell.style.fontWeight = "bold";
        cell.style.textAlign = "center";
    }

    for (let i = 0; i < jsonOutput["assignation"].length; i++) {
        let row = table.insertRow(i);
        row.style.background = "#EFEFEF";
        let machine = row.insertCell(0);
        machine.innerHTML = jsonOutput["assignation"][i]["id"];
        machine.style.background = "#DFDFDF";
        machine.style.width = 500;
        for (j = 0; j < jsonOutput["cost"]-1; j++) {
            let cell = row.insertCell(j+1);
            cell.style.width = 155;
        } 

        for (let task of jsonOutput["assignation"][i]["tasks"]) {
            if (!(task["order"] in colorMap)) {
                let color = "#" + Math.floor(Math.random()*16777215).toString(16);
                colorMap[task["order"]] = color;
            }
            let startCell = parseInt(task["start_at"]);
            let endCell = parseInt(task["end_at"]);

            for (k = startCell; k < endCell; k++) {
                row.cells[k].style.border = "medium solid #000000";
                if (k != startCell) {
                    row.cells[k].style.borderLeft = null;
                }
                if (k != endCell - 1) {
                    row.cells[k].style.borderRight = null;
                }
                row.cells[k].style.background = colorMap[task["order"]];
            }
        }
    }
    drawLegend(colorMap);
}

function drawLegend(colorMap) {
    let legend = document.getElementById("legend");
    legend.innerHTML = "";

    for (const m in colorMap) {
        let row = legend.insertRow(0);

        let order = row.insertCell(0);
        order.innerHTML = m;
        order.style.textAlign = "center";

        let color = row.insertCell(1);
        color.style.background = colorMap[m];
        color.style.textAlign = "center";
    }
    let row = legend.insertRow(0);
    row.style.textAlign = "center";
    let cellOrder = row.insertCell(0);
    cellOrder.innerHTML = "Order";
    cellOrder.style.width = 200;

    let cellColor = row.insertCell(1);
    cellColor.innerHTML = "Color";
    cellColor.style.width = 200;
}


function drawSchedule2(jsonOutput) {
    let colorMap = new Map();
    let table = document.getElementById("scheduleTable");

    let row = table.insertRow(0);
    row.insertCell(0);
    for (j = 0; j < jsonOutput["cost"]; j++) {
        let cell = row.insertCell(j + 1);
        cell.innerHTML = (j + 1).toString();
        cell.height = 23;
        cell.style.fontWeight = "bold";
        cell.style.textAlign = "center";
    }

    for (let i = 0; i < jsonOutput["assignation"].length; i++) {
        let row = table.insertRow(i);
        row.style.background = "#EFEFEF";
        let machine = row.insertCell(0);
        machine.innerHTML = "Machine " + jsonOutput["assignation"][i]["id"].substring(6, 8);
        machine.style.background = "#DFDFDF";
        machine.style.width = 500;
        for (j = 0; j < jsonOutput["cost"]; j++) {
            let cell = row.insertCell(j + 1);
            cell.style.width = 155;
        } 

        for (let task of jsonOutput["assignation"][i]["tasks"]) {
            if (!(task["order"] in colorMap)) {
                let color = "#" + Math.floor(Math.random()*16777215).toString(16);
                colorMap[task["order"]] = color;
            }
            let startCell = parseInt(task["start_at"]);
            let endCell = parseInt(task["end_at"]);
            

            for (k = startCell; k < endCell; k++) {
                row.cells[k + 1].style.border = "medium solid #000000";
                if (k != startCell) {
                    row.cells[k + 1].style.borderLeft = null;
                }
                if (k != endCell - 1) {
                    row.cells[k + 1].style.borderRight = null;
                }
                row.cells[k + 1].style.background = colorMap[task["order"]];
            }
        }
    }
    drawLegend(colorMap);
}

function deleteTable(myTable) {
    document.getElementById("myTable").deleteRow(0);
}
