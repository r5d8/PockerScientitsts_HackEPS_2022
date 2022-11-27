symbolicOutput(0).  % set to 1 to see symbolic output only; 0 otherwise.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To use this prolog template for other optimization problems, replace the code parts 1,2,3,4 below. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%% INPUT:

%:-[prolog_input_challenge_2].
machineTasks(m0,[o0t1,o2t1]).
machineTasks(m1,[o0t0,o1t0,o2t2,o3t0]).
machineTasks(m2,[o2t0,o3t1]).
machineConfig(m0, 0.1, 0.2, 0.8, 1, 3).
machineConfig(m1, 0.1, 0.1, 0.6, 0.2, 4).
machineConfig(m2, 0.3, 0.1, 1, 0, 5).
orders(o0,[o0t0,o0t1]).
orders(o1,[o1t0]).
orders(o2,[o2t0,o2t1,o2t2]).
orders(o3,[o3t0,o3t1]).
taskQuantity(o0t0,2).
taskQuantity(o0t1,2).
taskQuantity(o1t0,4).
taskQuantity(o2t0,2).
taskQuantity(o2t1,2).
taskQuantity(o2t2,1).
taskQuantity(o3t0,3).
taskQuantity(o3t1,3).
maxHourInput(100).


%%%%%%%%%%%%%%%%%%%%% END INPUT. %%%%%%%%%%%%%%%%%%%%%


%%%%%% Some helpful definitions to make the code cleaner:

machine(M) :- machineTasks(M,_).
task(T) :- taskQuantity(T,_).
hour(H) :- 1 =< H.
hourToDay(H,D) :- hour(H), OffH is max(0, H-16), (OffH = 0 -> D is 1; D is 2+div(floor(OffH-1),24)).
preceedes(T,S) :- orders(_,L), nth1(X,L,T), nth1(Y,L,S), X<Y.

quantities([], 0).
quantities([T|L], QS):- taskQuantity(T, Q), quantities(L, PrevQ), QS is PrevQ+Q.

execTimeOfMachineByQItems(M, Q, T):- machineConfig(M,_,_,Mult,Add,_), T is Mult*Q+Add.

isWorkHour(H):- hourIsWorkDay(H), hourToDay(H,D), DayH is H-16-24*(D-2), DayH >= 9, DayH =< 17.
isWorkDay(D):- Dmod7 is mod(D,7), Dmod7 > 0, Dmod7 < 6.
hourIsWorkDay(H):- hourToDay(H,D), isWorkDay(D).
containedInWorkHours(I, F):- isWorkHour(I), isWorkHour(F), hourToDay(I,D), hourToDay(F,D).
validLoad(M,I,F):- machineConfig(M,L,_,_,_,_), F is I+L, containedInWorkHours(I,F).
validUnload(M,I,F):- machineConfig(M,_,U,_,_,_), F is I+U, containedInWorkHours(I,F).

findNextWorkHour(H,H):- isWorkHour(H).
findNextWorkHour(H,WH):- hourToDay(H,D), D1 is D+1, isWorkDay(D1), WH is (D1-1)*24+1.
findNextWorkHour(H,WH):- hourToDay(H,D), D1 is D+3, isWorkDay(D1), WH is (D1-1)*24+1.

machineExecFinishesAt(M, TL, I, F):- machineTasks(M, L), subset(TL,L), machineConfig(M, _, UT, _, _, MaxI), validLoad(M,I,FiLT), quantities(TL,Q), Q=<MaxI, execTimeOfMachineByQItems(M,Q,T), ((IniUT is FiLT+T, validUnload(M,IniUT,Fin)) -> F is Fin; (PH is FiLT+T+UT, findNextWorkHour(PH, NWH), validUnload(M,NWH,F))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1.- Declare SAT variables to be used

satVariable( assignation(T,H) ):- task(T), hour(H). % Means task T is assigned to an execution batch that starts to load at time H.
satVariable( execution(M,TL,I,F) ):- machineExecFinishesAt(M, TL, I, F). % Means machine M makes execution with tasks TL starting at I, finishing at F.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. This predicate writeClauses(MaxCost) generates the clauses that guarantee that
% a solution with cost at most MaxCost is found

writeClauses(infinite):- !, maxHourInput(MaxHour), writeClauses(MaxHour),!.
writeClauses(MaxHour):-
    relateSatVars,
    tasksInsideTimeWindow(MaxHour),
    tasksOfSameOrderSorted(MaxHour),
    nonOverlappingTasksByMachine(MaxHour),
    tasksGetAssignedOnce(MaxHour),
    true,!.
writeClauses(_):- told, nl, write('writeClauses failed!'), nl,nl, halt.

%Done
relateSatVars:-
    machine(M),
    findall( assignation(T,_), (machineTasks(M,MT), member(T,MT)), Lits ),
    findall( Tk, (member(assignation(Tk,_),Lits)), TL),
    machineExecFinishesAt(M, TL, H, F),
    member(assignation(TA,H), Lits),
    writeClause(-execution(M,TL,H,F), assignation(TA,H)),
    fail.
relateSatVars.

%Done
tasksInsideTimeWindow(MaxHour) :- 
    machineTasks(M,MT), between(1,MaxHour,I), 
    maxHourInput(INP), NMH is MaxHour+1, between(NMH, INP,F), F>MaxHour, 
    subset(TL,MT),
    writeClause([-execution(M,TL,I,F)]),
    fail.
tasksInsideTimeWindow(_).

%Done
nonOverlappingTasksByMachine(MaxHour):-
    machine(M),
    machineTasks(M,L),
    subset(TL1,L),
    subset(TL2,L),
    \listEquals(TL1,TL2),
    between(1,MaxHour,H1),
    between(1,MaxHour,H2),
    H1 =< H2,
    machineExecFinishesAt(M, TL1, H1, F1),
    H2 =< F1,
    machineExecFinishesAt(M, TL2, H2, F2),
    writeClause([-execution(M,TL1,H1,F1),-execution(M,TL2,H2,F2)]),
    fail.
nonOverlappingTasksByMachine(_).

listEquals(A,B):- subset(A,B), subset(B,A).

%Done
tasksOfSameOrderSorted(MaxHour):-
    task(T1),
    task(T2),
    preceedes(T1,T2),
    findall( execution(M,TL,H,_), (machineTasks(M,MT), subset(TL,MT), member(T1,TL), between(1,MaxHour,H)), Lits ),
    member(execution(M,TL,I,F), Lits),
    between(I,F,H2),
    writeClause([-execution(M,TL,I,F),-assignation(T2,H2)]),
    fail.
tasksOfSameOrderSorted(_).

%Done
tasksGetAssignedOnce(MaxHour):-
    task(T),
    findall( assignation(T,H), between(1,MaxHour,H), Lits ),
    exactly(1,Lits),
    fail.
tasksGetAssignedOnce(_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. This predicate displays a given solution M:

displaySol(Model):- write('SOLUTIOOON'), nl, fail.
    %machineTasks(M,LM),
    %write('Machine: '), write(M), nl,
    %task(T), member(T,LM),
    %write('Task: '), write(T), write(' '),
    %member( assignation(T,H), Model ),
    %taskDuration(T,D),
    %EndT is H+D-1,
    %write(H), write('-'), write(EndT), nl, fail.
displaySol(_):- nl,nl,!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. This predicate computes the cost of a given solution M:
    
costOfThisSolution(M, Cost):-
    findall(EndT, member(execution(_,_,_,EndT),M), FinishingHours),
    sort(FinishingHours, SFH),
    reverse(SFH, [Cost|_]).
    
% precondition: elements in list are ordered in increasing value
maximumDifferenceBetweenConsecutiveElems([],0).
maximumDifferenceBetweenConsecutiveElems([_],0).
maximumDifferenceBetweenConsecutiveElems([A,B|L],N):-
    maximumDifferenceBetweenConsecutiveElems([B|L],N),
    N > B-A, !.
maximumDifferenceBetweenConsecutiveElems([A,B|_],N):-
    N is B-A.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% No need to modify anything below this line:

main:-  symbolicOutput(1), !, writeClauses(infinite), halt.   % print the clauses in symbolic form and halt
main:-
    told, write('Looking for initial solution with arbitrary cost...'), nl,
    initClauseGeneration,
    tell(clauses), writeClauses(infinite), told,
    tell(header),  writeHeader,  told,
    numVars(N), numClauses(C), 
    write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
    shell('cat header clauses > infile.cnf',_),
    write('Launching minisat...'), nl,
    shell('minisat infile.cnf model', Result),  % if sat: Result=10; if unsat: Result=20.
    treatResult(Result,[]),!.

treatResult(20,[]       ):- write('No solution exists.'), nl, halt.
treatResult(20,BestModel):-
    nl,costOfThisSolution(BestModel,Cost), write('Unsatisfiable. So the optimal solution was this one with cost '),
    write(Cost), write(':'), nl, displaySol(BestModel), 
    write('%% END OF FOUND SOLUTION %%'),
    nl,nl,halt.
treatResult(10,_):- %   shell('cat model',_),
    nl,write('Solution found '), flush_output,
    see(model), symbolicModel(M), seen,
    costOfThisSolution(M,Cost),
    write('with cost '), write(Cost), nl,nl,
    displaySol(M), 
    Cost1 is Cost-1,   nl,nl,nl,nl,nl,  write('Now looking for solution with cost '), write(Cost1), write('...'), nl,
    initClauseGeneration, tell(clauses), writeClauses(Cost1), told,
    tell(header),  writeHeader,  told,
    numVars(N),numClauses(C),
    write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
    shell('cat header clauses > infile.cnf',_),
    write('Launching minisat...'), nl,
    shell('minisat infile.cnf model', Result),  % if sat: Result=10; if unsat: Result=20.
    treatResult(Result,M),!.
treatResult(_,_):- write('cnf input error. Wrote something strange in your cnf?'), nl,nl, halt.
    

initClauseGeneration:-  %initialize all info about variables and clauses:
	retractall(numClauses(   _)),
	retractall(numVars(      _)),
	retractall(varNumber(_,_,_)),
	assert(numClauses( 0 )),
	assert(numVars(    0 )),     !.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w(-Var):- symbolicOutput(1), satVariable(Var), write(-Var), write(' '),!. 
w( Var):- symbolicOutput(1), satVariable(Var), write( Var), write(' '),!. 
w(-Var):- satVariable(Var),  var2num(Var,N),   write(-), write(N), write(' '),!.
w( Var):- satVariable(Var),  var2num(Var,N),             write(N), write(' '),!.
w( Lit):- told, write('ERROR: generating clause with undeclared variable in literal '), write(Lit), nl,nl, halt.


% given the symbolic variable V, find its variable number N in the SAT solver:
var2num(V,N):- hash_term(V,Key), existsOrCreate(V,Key,N),!.
existsOrCreate(V,Key,N):- varNumber(Key,V,N),!.                            % V already existed with num N
existsOrCreate(V,Key,N):- newVarNumber(N), assert(varNumber(Key,V,N)), !.  % otherwise, introduce new N for V

writeHeader:- numVars(N),numClauses(C), write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-     retract( numClauses(N0) ), N is N0+1, assert( numClauses(N) ),!.
newVarNumber(N):- retract( numVars(   N0) ), N is N0+1, assert(    numVars(N) ),!.

% Getting the symbolic model M from the output file:
symbolicModel(M):- get_code(Char), readWord(Char,W), symbolicModel(M1), addIfPositiveInt(W,M1,M),!.
symbolicModel([]).
addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.
addIfPositiveInt(_,L,L).
readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c
readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
:-dynamic(varNumber / 3).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits) :- symbolicOutput(1), write( Var ), write(' <--> or('), write(Lits), write(')'), nl, !. 
expressOr( Var, Lits ):- member(Lit,Lits), negate(Lit,NLit), writeClause([ NLit, Var ]), fail.
expressOr( Var, Lits ):- negate(Var,NVar), writeClause([ NVar | Lits ]),!.

% Express that Var is equivalent to the conjunction of Lits:
expressAnd( Var, Lits) :- symbolicOutput(1), write( Var ), write(' <--> and('), write(Lits), write(')'), nl, !. 
expressAnd( Var, Lits):- member(Lit,Lits), negate(Var,NVar), writeClause([ NVar, Lit ]), fail.
expressAnd( Var, Lits):- findall(NLit, (member(Lit,Lits), negate(Lit,NLit)), NLits), writeClause([ Var | NLits]), !.


%%%%%% Cardinality constraints on arbitrary sets of literals Lits:

exactly(K,Lits):- symbolicOutput(1), write( exactly(K,Lits) ), nl, !.
exactly(K,Lits):- atLeast(K,Lits), atMost(K,Lits),!.

atMost(K,Lits):- symbolicOutput(1), write( atMost(K,Lits) ), nl, !.
atMost(K,Lits):-   % l1+...+ln <= k:  in all subsets of size k+1, at least one is false:
	negateAll(Lits,NLits),
	K1 is K+1,    subsetOfSize(K1,NLits,Clause), writeClause(Clause),fail.
atMost(_,_).

atLeast(K,Lits):- symbolicOutput(1), write( atLeast(K,Lits) ), nl, !.
atLeast(K,Lits):-  % l1+...+ln >= k: in all subsets of size n-k+1, at least one is true:
	length(Lits,N),
	K1 is N-K+1,  subsetOfSize(K1, Lits,Clause), writeClause(Clause),fail.
atLeast(_,_).

negateAll( [], [] ).
negateAll( [Lit|Lits], [NLit|NLits] ):- negate(Lit,NLit), negateAll( Lits, NLits ),!.

negate( -Var,  Var):-!.
negate(  Var, -Var):-!.

subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
