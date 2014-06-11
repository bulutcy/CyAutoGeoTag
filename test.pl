%calculate weight of putted objects
weight([],0).
weight([object(_,W) | Tail], X) :-
  weight(Tail,TailW),
  X is W + TailW.

%creates possible solutions of different object combinations
subseq([],[]).
subseq([Item | TailX], [Item | TailY]) :-
  subseq(TailX,TailY).
subseq(X, [_ | TailY]) :-
  subseq(X,TailY).

%checks if such objects can be put in this box
legalObjectLot(ObjectLot,Capacity,ObjectBag):-
  subseq(ObjectBag,ObjectLot),
  weight(ObjectBag,W),
  W =< Capacity.

%calculates for all legal object list
legalObjectList(ObjectLot, Capacity, ListOfLegalObjects) :-
                        findall(LegalObject, legalObjectLot(ObjectLot, Capacity, LegalObject), ListOfLegalObjects).

%calculation start point for which objects should be putted in this box
maximumWeigth([LEGAL | LEGALS], MAXWEIGHTS) :- weight(LEGAL, WEIGHTS), maxWeights(LEGALS, WEIGHTS, LEGAL, MAXWEIGHTS).

%calculation for object pairs for best result
maxWeights([], MAXWEIGHTS, MAXWEIGHTLEGAL, MAXWEIGHTLEGAL).
maxWeights([LEGAL | LEGALS], MAXWEIGHTS, MAXWEIGHTLEGAL, OUTPUT) :- weight(LEGAL, NEWWEIGHTS), NEWWEIGHTS > MAXWEIGHTS,
                                                           maxWeights(LEGALS, NEWWEIGHTS, LEGAL, OUTPUT).
maxWeights([LEGAL | LEGALS], MAXWEIGHTS, MAXWEIGHTLEGAL, OUTPUT) :- weight(LEGAL, NEWWEIGHTS), NEWWEIGHTS =< MAXWEIGHTS,
                                                           maxWeights(LEGALS, MAXWEIGHTS, MAXWEIGHTLEGAL, OUTPUT).

%start calculation for a spesific box
findForBox(Objects,Capacity,PuttedObjects,TotalWeight) :-  legalObjectList(Objects, Capacity, R),
                                          maximumWeigth(R, PuttedObjects),
                                          weight(PuttedObjects,TotalWeight).


%start iteration of box pairs and removes putted objects
iterBox([],_,_).
iterBox([box(Box,Capacity)| Tail], X, Objects) :-
	findForBox(Objects,Capacity,PuttedObjects,TotalWeight),
    print('\n Box:'),print(Box),
    print(', Objects: '),print(PuttedObjects),
    subtract(Objects, PuttedObjects, ObjectsRemaining ),
    %  print('\n'),print('obj: '),print(OX),
	iterBox(Tail,TailX, ObjectsRemaining).




%permutation of box pairs
add(X,L,[X|L]).
add(X,[L|H],[L|R]):- add(X,H,R).

permut([],[]).
permut([L|H],R):- permut(H,R1),
	add(L,R1,R).


%quick sort system starts
quicksortBoxes([X|Xs],Ys) :-
  partitionBoxes(Xs,X,Left,Right),
  quicksortBoxes(Left,Ls),
  quicksortBoxes(Right,Rs),
  append(Ls,[X|Rs],Ys).
quicksortBoxes([],[]).

boxVal(box(_,VALX),VAL) :- VAL is VALX.
partitionBoxes([X|Xs],Y,[X|Ls],Rs) :-
	boxVal(X,XVAL),
	boxVal(Y,YVAL),
	XVAL =< YVAL, partitionBoxes(Xs,Y,Ls,Rs).
partitionBoxes([X|Xs],Y,Ls,[X|Rs]) :-
		boxVal(X,XVAL),
	boxVal(Y,YVAL),
	XVAL > YVAL, partitionBoxes(Xs,Y,Ls,Rs).
partitionBoxes([],Y,[],[]).

quicksortObjects([X|Xs],Ys) :-
  partitionObjects(Xs,X,Left,Right),
  quicksortObjects(Left,Ls),
  quicksortObjects(Right,Rs),
  append(Ls,[X|Rs],Ys).
quicksortObjects([],[]).

objectVal(object(_,VALX),VAL) :- VAL is VALX.
partitionObjects([X|Xs],Y,[X|Ls],Rs) :-
	objectVal(X,XVAL),
	objectVal(Y,YVAL),
	XVAL =< YVAL, partitionObjects(Xs,Y,Ls,Rs).
partitionObjects([X|Xs],Y,Ls,[X|Rs]) :-
		objectVal(X,XVAL),
	objectVal(Y,YVAL),
	XVAL > YVAL, partitionObjects(Xs,Y,Ls,Rs).
partitionObjects([],Y,[],[]).


append([],Ys,Ys).
append([X|Xs],Ys,[X|Zs]) :- append(Xs,Ys,Zs).


reverse([],Z,Z).
reverse([H|T],Z,Acc) :- reverse(T,Z,[H|Acc]).




%Application MAIN start points


calculateBoxes(Objects,Boxes) :-
	quicksortObjects(Objects,ObjectsSorted),
	reverse(ObjectsSorted,ObjectsReverseSorted, []),
	quicksortBoxes(Boxes,BoxesSorted),
	iterBox(BoxesSorted,_,ObjectsReverseSorted).

calculateBoxes2(Objects,Boxes) :-
	quicksortObjects(Objects,ObjectsSorted),
	quicksortBoxes(Boxes,BoxesSorted),
	reverse(BoxesSorted,BoxesReverseSorted, []),
	iterBox(BoxesReverseSorted,_,ObjectsSorted).

calculateBoxes3(Objects,Boxes) :-
	permutation(Boxes,BoxPermut),
	iterBox(BoxPermut,_,ObjectsReverseSorted).


