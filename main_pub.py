import os
import sys
import argparse
import json
from functools import reduce

from time import time
from datetime import timedelta
import threading

which_order = lambda tid: tid.split('t')[0]
which_task_number = lambda tid: int(tid.split('t')[1])

mac_to_id = {} #Map a machine name to its id
id_to_mac = {} #Map a machine's id to its name

ord_to_id = {}
id_to_ord = {}

deltatime = 0

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
    plInput = open("./challenge1/prolog_input_challenge_1.pl", "w")

    #order data
    machines = {}
    orders = {}
    tasks = {}
    
    mac_to_id = {} #Map a machine name to its id
    id_to_mac = {} #Map a machine's id to its name

    ord_to_id = {}
    id_to_ord = {}
    
    C1_get_tasks_orders(data, machines, orders, tasks, ord_to_id, id_to_ord)
    
    #create literals for prolog
    C1_write_literals(plInput, machines, orders, tasks, mac_to_id, ord_to_id)

    plInput.close()

    ###########
    # Execute
    ###########

    ###########
    # Process
    ###########

    return 0

def thread_function_challenge1():
    global init_time, deltatime
    init_time = deltatime = 0
    print("Start_compilation")
    os.system('./challenge1/make problem1')
    init_time = time()
    print("Start_compu")
    os.system('./challenge1/problem1 > prolog_output_challenge_1.txt')
    deltatime = timedelta(seconds=(time() - init_time))

def api_challenge_1_prolog(json_info):
    data = json_info 
    global mac_to_id, id_to_mac, ord_to_id, id_to_ord
    
    # opening/creating output file
    plInput = open("./challenge1/prolog_input_challenge_1.pl", "w")
        
    ord_to_id = {}
    id_to_ord
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

    ##start_execution
    x = threading.Thread(target=thread_function_challenge1, daemon = True)
    x.start()

    return

def api_ask_end():
    global init_time, deltatime
    if deltatime == 0:
        return "", False
    else:
        global mac_to_id, id_to_mac, ord_to_id, id_to_ord
        
        file_path = "./challenge1/"

        raw = ""
        with open(file_path + "prolog_output_challenge_1.txt", "r") as f:
            raw = reduce(lambda acc, x: acc + x + '\n', [line.strip() for line in f.readlines()], "")
        
        #raw = open(file_path + "prolog_output_challenge_1.txt", "r")
        raw_sol = raw.split("Unsatisfiable. So the optimal solution was this one with cost ")

        if len(raw_sol) > 0: raw_sol = raw_sol[1]
        else : 
            print("UNSAT!!")
            #return 0

        raw_sol = raw_sol.split('\n\n%% END OF FOUND SOLUTION %%')[0]
        cost, assig = raw_sol.split(':\n')

        machines_res = []

        for m in assig.split("Machine: ")[1:]:
            t = m.split('\n')
            dicMac = {"id" : id_to_mac[t[0]]}
            dicMac["tasks"] = []

            for tt in t[1:-1]:
                ttt = tt.split(' ')
                dicMac["tasks"].append(
                    {
                        "order": id_to_ord[which_order(ttt[1])],
                        "task_number": which_task_number(ttt[1]),
                        "start_at": int(ttt[2].split('-')[0]),
                        "end_at": int(ttt[2].split('-')[1])
                    }
                )
                #print(dicMac)
            
            machines_res.append(dicMac)

        result_processed = {"cost" : cost, "assignation" : machines_res}
        return result_processed, True


        








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
