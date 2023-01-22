import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Backend {
  'get_all_proposals' : ActorMethod<[], Array<[Id, Proposal]>>,
  'get_proposal' : ActorMethod<[Id], [] | [Proposal]>,
  'id' : ActorMethod<[], Principal>,
  'modiFied' : ActorMethod<
    [bigint, bigint, bigint],
    { 'Ok' : Proposal } |
      { 'Err' : string }
  >,
  'nameMbt' : ActorMethod<[], string>,
  'submit_proposal' : ActorMethod<
    [string],
    { 'Ok' : Proposal } |
      { 'Err' : string }
  >,
  'totalMbt' : ActorMethod<[], bigint>,
  'vote' : ActorMethod<[Id, boolean], { 'Ok' : string } | { 'Err' : string }>,
  'whoami' : ActorMethod<[], Principal>,
}
export type Id = bigint;
export type List = [] | [[Principal, List]];
export interface Proposal {
  'title' : string,
  'minVotes' : bigint,
  'votes' : { 'no' : bigint, 'yes' : bigint },
  'open' : boolean,
  'user' : Principal,
  'votersList' : List,
  'maxVotes' : bigint,
}
export interface _SERVICE extends Backend {}
