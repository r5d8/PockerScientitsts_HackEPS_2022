async function postNewScheduleComputation(json_contents, path) {
        let url = path;

        let res = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: json_contents,
        });
}

async function getNewScheduleResult(path) {
    return await fetch(path);
}

function computeChallenge1(json_contents) {
    const challenge1Path = 'localhost:5000/challenge1';
    postNewScheduleComputation(json_contents, challenge1Path).then(data => {
        let gotResponse = false;
        let output_json = "";
        function poll() {
            let timeout = setTimeout({
                //Make get request.
                getNewScheduleResult(challenge1Path).then(response=>{
                    console.log(response);
                    // If ready return data.
                    if (response.status === 200) {
                        gotResponse = true;
                        output_json = response.data;
                    } else if (response.status === 204) {
                        // Else poll again
                        poll();
                    }
                });
            }, 1000);
            if (gotResponse) clearTimeout(timeout);
        }
    });
    
    return output_json;
    
    /*console.log("Computing challenge 1 (" + path + ")....");
    let jsonFile = {
      "solution":
    [
      {
        "id": "mach::00",
        "tasks": [
          {
            "order": "order_0011",
            "task_number": "0",
            "start_at": "0",
            "end_at": "5"
          },
          {
            "order": "order_0006",
            "task_number": "1",
            "start_at": "5",
            "end_at": "7"
          },
          {
            "order": "order_0012",
            "task_number": "2",
            "start_at": "7",
            "end_at": "10"
          },
          {
            "order": "order_0012",
            "task_number": "3",
            "start_at": "10",
            "end_at": "16"
          }
        ]
      },
      {
        "id": "mach::01",
        "tasks": [
          {
            "order": "order_0008",
            "task_number": "0",
            "start_at": "0",
            "end_at": "1"
          },
          {
            "order": "order_0007",
            "task_number": "1",
            "start_at": "1",
            "end_at": "5"
          }
        ]
      },
      {
        "id": "mach::02",
        "tasks": [
          {
            "order": "order_0006",
            "task_number": "0",
            "start_at": "0",
            "end_at": "5"
          },
          {
            "order": "order_0010",
            "task_number": "2",
            "start_at": "7",
            "end_at": "11"
          },
          {
            "order": "order_0009",
            "task_number": "1",
            "start_at": "14",
            "end_at": "15"
          },
          {
            "order": "order_0005",
            "task_number": "4",
            "start_at": "35",
            "end_at": "38"
          }
        ]
      },
      {
        "id": "mach::03",
        "tasks": [
          {
            "order": "order_0002",
            "task_number": "0",
            "start_at": "0",
            "end_at": "5"
          }
        ]
      }
    ],
    "cost": 38};
    
    return jsonFile;   */   
}

function computeChallenge2(path) {
    console.log("Computing challenge 2 (" + path + ")....");
    let jsonFile = {
      "solution":
    [
      { "id": "mach::00", "tasks": [] },
      {
        "id": "mach::01",
        "tasks": [
          {
            "order": "order_0011",
            "task_number": "0",
            "start_at": "0",
            "end_at": "5"
          },
          {
            "order": "order_0006",
            "task_number": "1",
            "start_at": "0",
            "end_at": "4"
          },
          {
            "order": "order_0012",
            "task_number": "2",
            "start_at": "7",
            "end_at": "10"
          },
          {
            "order": "order_0012",
            "task_number": "3",
            "start_at": "10",
            "end_at": "16"
          }
        ]
      },
      {
        "id": "mach::02",
        "tasks": [
          {
            "order": "order_0008",
            "task_number": "0",
            "start_at": "0",
            "end_at": "1"
          },
          {
            "order": "order_0007",
            "task_number": "0",
            "start_at": "1",
            "end_at": "5"
          }
        ]
      },
      {
        "id": "mach::03",
        "tasks": [
          {
            "order": "order_0006",
            "task_number": "0",
            "start_at": "0",
            "end_at": "5"
          },
          {
            "order": "order_0010",
            "task_number": "2",
            "start_at": "7",
            "end_at": "11"
          },
          {
            "order": "order_0009",
            "task_number": "1",
            "start_at": "14",
            "end_at": "15"
          },
          {
            "order": "order_0005",
            "task_number": "4",
            "start_at": "35",
            "end_at": "38"
          }
        ]
      },
    ],
    "cost": 39
    };
      
    return jsonFile;      
}
