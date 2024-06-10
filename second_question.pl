% Figure 17.8 (3rd) or 17.6 (4th) Edition
% A planner based on goal regression.
% This planner searches in iterative-deepening style.

% A means-ends planner with goal regression
plan(State, Goals, Plan) :-
    satisfied(State, Goals, []), !.
plan(State, Goals, Plan) :-
    append(PrePlan, [Action], Plan),
    select(State, Goals, Goal),
    achieves(Action, Goal, Vars),
    can(Action, Condition, Vars),
    preserves(Action, Goals, Vars),
    regress(Goals, Action, RegressedGoals, Vars),
    plan(State, RegressedGoals, PrePlan).

% satisfied(State, Goals) :-
%   delete_all(Goals, State, []).              % All Goals in State
% --------------------------------------------
% Suggestion from  page 400, 4th edition
satisfied(State, [], _).
satisfied(State, [Goal | Goals], Vars) :-
    holds(Goal, Vars),
    satisfied(State, Goals, Vars).

holds(different(X, Y), Vars) :-
    \+ X = Y,
    !,
    Vars = [].
holds(different(X, Y), Vars) :-
    X == Y,
    false,
    Vars = [].

% --------------------------------------------
select(State, Goals, Goal) :-
    member(Goal, Goals).

% --------------------------------------------
achieves(Action, Goal, Vars) :-
    adds(Action, Goals, Vars),
    member(Goal, Goals).

% --------------------------------------------
preserves(Action, Goals, Vars) :-
    deletes(Action, Relations, Vars),
    \+ (member(Goal, Relations), member(Goal, Goals)).

% --------------------------------------------
regress(Goals, Action, RegressedGoals, Vars) :-
    adds(Action, NewRelations, Vars),
    delete_all(Goals, NewRelations, RestGoals, Vars),
    can(Action, Condition, Vars),
    addnew(Condition, RestGoals, RegressedGoals, Vars).

% --------------------------------------------
addnew([], L, L, _).
addnew([Goal | _], Goals, _, _) :-
    impossible(Goal, Goals), !, fail.
addnew([X | L1], L2, L3, Vars) :-
    member(X, L2), !,
    addnew(L1, L2, L3, Vars).
addnew([X | L1], L2, [X | L3], Vars) :-
    addnew(L1, L2, L3, Vars).

% --------------------------------------------
delete_all(L1, L2, Diff, Vars) :-
    delete_all(L1, L2, Diff, Vars, []).

delete_all([], _, [], _, []).
delete_all([X | L1], L2, Diff, Vars, Acc) :-
    member(X, L2), !,
    delete_all(L1, L2, Diff, Vars, Acc).
delete_all([X | L1], L2, [X | Diff], Vars, Acc) :-
    delete_all(L1, L2, Diff, Vars, Acc).

% --------------------------------------------
member(X, [X | _]).
member(X, [_ | T]) :-
    member(X, T).

delete(X, [X | Tail], Tail).
delete(X, [Y | Tail], [Y | Tail1]) :-
    delete(X, Tail, Tail1).

impossible(Goal, Goals) :-
    \+ Goal,
    member(Goal, Goals).

can(Action, Condition, Vars) :-
    Action =.. [Name | Args],
    Condition =.. [Name | Args],
    Vars = Args.