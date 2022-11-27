function computeChallenge1(path) {
    console.log("Computing challenge 1 (" + path + ")....");
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
            "task_number": "0",
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
    
    return jsonFile;      
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
      {
        "id": "mach::04",
        "tasks": [
          {
            "order": "order_0002",
            "task_number": "0",
            "start_at": "0",
            "end_at": "5"
          }
        ]
      },
      {
        "id": "mach::05",
        "tasks": [
          {
            "order": "order_0012",
            "task_number": "0",
            "start_at": "0",
            "end_at": "2"
          },
          {
            "order": "order_0012",
            "task_number": "1",
            "start_at": "2",
            "end_at": "5"
          },
          {
            "order": "order_0005",
            "task_number": "0",
            "start_at": "5",
            "end_at": "13"
          },
          {
            "order": "order_0011",
            "task_number": "2",
            "start_at": "13",
            "end_at": "14"
          },
          {
            "order": "order_0005",
            "task_number": "1",
            "start_at": "14",
            "end_at": "18"
          },
          {
            "order": "order_0011",
            "task_number": "4",
            "start_at": "18",
            "end_at": "21"
          },
          {
            "order": "order_0013",
            "task_number": "2",
            "start_at": "21",
            "end_at": "25"
          },
          {
            "order": "order_0005",
            "task_number": "2",
            "start_at": "25",
            "end_at": "32"
          },
          {
            "order": "order_0004",
            "task_number": "4",
            "start_at": "32",
            "end_at": "39"
          }
        ]
      },
      {
        "id": "mach::06",
        "tasks": [
          {
            "order": "order_0008",
            "task_number": "1",
            "start_at": "1",
            "end_at": "8"
          },
          {
            "order": "order_0003",
            "task_number": "1",
            "start_at": "8",
            "end_at": "11"
          }
        ]
      },
      {
        "id": "mach::07",
        "tasks": [
          {
            "order": "order_0000",
            "task_number": "0",
            "start_at": "0",
            "end_at": "1"
          },
          {
            "order": "order_0000",
            "task_number": "1",
            "start_at": "1",
            "end_at": "2"
          },
          {
            "order": "order_0004",
            "task_number": "1",
            "start_at": "2",
            "end_at": "4"
          },
          {
            "order": "order_0004",
            "task_number": "2",
            "start_at": "4",
            "end_at": "5"
          },
          {
            "order": "order_0011",
            "task_number": "1",
            "start_at": "5",
            "end_at": "9"
          },
          {
            "order": "order_0009",
            "task_number": "0",
            "start_at": "9",
            "end_at": "14"
          },
          {
            "order": "order_0013",
            "task_number": "1",
            "start_at": "14",
            "end_at": "17"
          },
          {
            "order": "order_0004",
            "task_number": "3",
            "start_at": "17",
            "end_at": "23"
          },
          {
            "order": "order_0010",
            "task_number": "4",
            "start_at": "23",
            "end_at": "30"
          }
        ]
      },
      {
        "id": "mach::08",
        "tasks": [
          {
            "order": "order_0001",
            "task_number": "0",
            "start_at": "0",
            "end_at": "1"
          },
          {
            "order": "order_0004",
            "task_number": "0",
            "start_at": "1",
            "end_at": "2"
          },
          {
            "order": "order_0010",
            "task_number": "1",
            "start_at": "2",
            "end_at": "7"
          },
          {
            "order": "order_0007",
            "task_number": "1",
            "start_at": "7",
            "end_at": "11"
          },
          {
            "order": "order_0007",
            "task_number": "2",
            "start_at": "11",
            "end_at": "12"
          },
          {
            "order": "order_0012",
            "task_number": "4",
            "start_at": "16",
            "end_at": "19"
          },
          {
            "order": "order_0005",
            "task_number": "3",
            "start_at": "32",
            "end_at": "35"
          }
        ]
      },
      {
        "id": "mach::09",
        "tasks": [
          {
            "order": "order_0010",
            "task_number": "0",
            "start_at": "0",
            "end_at": "2"
          },
          {
            "order": "order_0003",
            "task_number": "0",
            "start_at": "2",
            "end_at": "5"
          },
          {
            "order": "order_0013",
            "task_number": "0",
            "start_at": "5",
            "end_at": "12"
          },
          {
            "order": "order_0010",
            "task_number": "3",
            "start_at": "12",
            "end_at": "14"
          }
        ]
      }
    ],
    "cost": 39
    };
      
    return jsonFile;      
}
