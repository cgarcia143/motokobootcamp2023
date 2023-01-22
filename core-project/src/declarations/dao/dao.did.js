export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const Id = IDL.Nat;
  List.fill(IDL.Opt(IDL.Tuple(IDL.Principal, List)));
  const Proposal = IDL.Record({
    'title' : IDL.Text,
    'minVotes' : IDL.Nat,
    'votes' : IDL.Record({ 'no' : IDL.Nat, 'yes' : IDL.Nat }),
    'open' : IDL.Bool,
    'user' : IDL.Principal,
    'votersList' : List,
    'maxVotes' : IDL.Nat,
  });
  const Backend = IDL.Service({
    'get_all_proposals' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(Id, Proposal))],
        ['query'],
      ),
    'get_proposal' : IDL.Func([Id], [IDL.Opt(Proposal)], ['query']),
    'id' : IDL.Func([], [IDL.Principal], []),
    'modiFied' : IDL.Func(
        [IDL.Nat, IDL.Nat, IDL.Nat],
        [IDL.Variant({ 'Ok' : Proposal, 'Err' : IDL.Text })],
        [],
      ),
    'nameMbt' : IDL.Func([], [IDL.Text], []),
    'submit_proposal' : IDL.Func(
        [IDL.Text],
        [IDL.Variant({ 'Ok' : Proposal, 'Err' : IDL.Text })],
        [],
      ),
    'totalMbt' : IDL.Func([], [IDL.Nat], []),
    'vote' : IDL.Func(
        [Id, IDL.Bool],
        [IDL.Variant({ 'Ok' : IDL.Text, 'Err' : IDL.Text })],
        [],
      ),
    'whoami' : IDL.Func([], [IDL.Principal], []),
  });
  return Backend;
};
export const init = ({ IDL }) => { return []; };
