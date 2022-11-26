import argparse
import json
from functools import reduce

def C1_get_machines(data, machines, mac_to_id, id_to_mac):
    for idm in range(len(data.get("machines"))):
        m = data.get("machines")[idm]
        machines[m.get('id')] = []
        mac_to_id[m.get('id')] = "m" + str(idm)
        id_to_mac["m" + str(idm)] = m.get('id')

def C1_get_tasks_orders(data, machines, orders, tasks, ord_to_id, id_to_ord):
    for ido in range(len(data.get("orders"))):
        ord = data.get("orders")[ido]

        name = ord.get('name')
        o_tasks = ord.get('tasks')

        orders[name] = []

        ord_to_id[name] = "o" + str(ido)
        id_to_ord["o" + str(ido)] = name

        for idt in range(len(o_tasks)):
            tas = o_tasks[idt]
            task_name = "o" + str(ido) + "t" + str(idt)
            
            tasks[task_name] = tas.get("duration")
            machines[tas.get("machine")].append(task_name)
            orders[name].append(task_name)

def C1_write_literals(plInput, machines, orders, tasks, mac_to_id, ord_to_id):
    literals = []

    for m in machines.items():
        l = "machineTasks(" + mac_to_id[m[0]] + ",["
        for t in m[1]:
            l += (t + ",")
        
        if len(m[1]) > 0: l = l[:-1]
        l += ("]).")

        literals.append(l)
    
    for o in orders.items():
        l = "orders(" + ord_to_id[o[0]] + ",["
        for t in o[1]:
            l += (t + ",")
        
        if len(m[1]) > 0: l = l[:-1]
        l += ("]).")
        literals.append(l)
    
    for t in tasks.items():
        l = "taskDuration(" + t[0] + "," + str(t[1]) + ")."
        literals.append(l)

    sumHoresTotal = reduce(lambda x, acc: x + acc, tasks.values(), 0)
    
    literals.append("maxHourInput(" + str(sumHoresTotal) + ").")

    for l in literals:
        plInput.write(l + "\n")

# Solution in hours 
def challenge_1(file_path):
    # input reading
    inJSON = open(file_path + "/challenge1/" + "challenge_1_input.json")
    data = json.load(inJSON)

    # opening/creating output file
    plInput = open("./prolog_input_challenge_1.pl", "w")

    #order data
    machines = {}
    orders = {}
    tasks = {}

    mac_to_id = {} #Map a machine name to its id
    id_to_mac = {} #Map a machine's id to its name

    ord_to_id = {}
    id_to_ord = {}
    
    C1_get_machines(data, machines, mac_to_id, id_to_mac)

    
    C1_get_tasks_orders(data, machines, orders, tasks, ord_to_id, id_to_ord)
    
    #create literals for prolog
    C1_write_literals(plInput, machines, orders, tasks, mac_to_id, ord_to_id)

    plInput.close()

    return 0


def challenge_2(file_path):
    # Remember! Solution in hours, and the same solution in days. Both ceiled to next integer
    # return toHours(solution), toDays(solution)
    return (0, 0)


def challenge_3(file_path):
    # No need a return
    return 0


def init(challenge=1, input='.'):
    challenge_fn = challenge_1 if challenge == 1 else challenge_2 if challenge == 2 else challenge_3
    return challenge_fn(input)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-C',
                        '--challenge',
                        type=int,
                        help='Number of challenge',
                        required=True,
                        choices=[x + 1 for x in range(3)])
    parser.add_argument(
        '--input',
        type=str,
        help='Input file name path',
        required=True,
    )

    # Structure:
    #   args.challenge: int (the number of challenge)
    #   args.input: str (the json input file path from here)
    args = parser.parse_args()
    init(args.challenge, args.input)
