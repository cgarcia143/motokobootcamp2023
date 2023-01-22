import HashMap "mo:base/HashMap";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Error "mo:base/Error";
import List "mo:base/List";

shared ({ caller = owner }) actor class Backend() = {

    type Proposal = {
        user: Principal;
        title: Text;
        minVotes: Nat;
        maxVotes: Nat;
        open: Bool;
        votersList: List.List<Principal>;
        votes: {
            yes: Nat;
            no: Nat; 
        };
    };

    var lastProposal: Proposal = {
        user = Principal.fromText("im2ae-jd6jx-vb4jw-d7ewc-g4lac-s6ghl-td23j-6ecje-hoqjk-xruqs-eae");
        title = "Motoko2022";
        minVotes = 1;
        maxVotes = 100;
        open = false;
        votersList = List.nil<Principal>();
        votes = {
            yes = 100;
            no = 0; 
        };
    };

    type Id = Nat; 
    stable var creator : Principal = owner; 
    // TO DEFINE;
    stable var arraData: [(Id,Proposal)] = [];
    var proporsals = HashMap.fromIter<Id, Proposal>(arraData.vals(),1, Nat.equal, Hash.hash);
    stable var postIdCount: Id = 0;

    let MBT : actor { icrc1_name  : () -> async Text; icrc1_balance_of  : ({owner:Principal; subaccount: ?[Nat8]}) -> async Nat } = actor ("db3eq-6iaaa-aaaah-abz6a-cai"); 

    public func nameMbt() : async Text {
        let name: Text = await MBT.icrc1_name();
        return name;
    };

    public shared({caller = user}) func totalMbt() : async Nat {
        let total: Nat = await MBT.icrc1_balance_of({owner=user; subaccount=null});
        return total;
    };


    public shared({caller = usuario}) func submit_proposal(this_payload : Text) : async {#Ok : Proposal; #Err : Text} {

        if(Principal.isAnonymous(usuario)) {
            return #Err("Anonymous caller");
        };

        let id: Id = postIdCount;
        postIdCount+=1;

        var createProposal: Proposal = {
            user = usuario;
            title = this_payload;
            minVotes = 1;
            open = true;
            maxVotes = 100;
            votersList = List.nil<Principal>();
            votes = {
                yes = 0;
                no = 0;
            };
        };

        proporsals.put(id, createProposal);

        #Ok(createProposal);
    };

    public shared({caller = usuario}) func modiFied(idPorposal: Nat, minTokens: Nat, maxVotess: Nat) : async {#Ok : Proposal; #Err : Text} {
        if(usuario == creator){
             let proporsal: ?Proposal = proporsals.get(idPorposal);
            switch(proporsal) {
                case(null) { return #Err("no exist") };

                case(?proporsal) { 
                    
                    var updateProporsal: Proposal = {
                        user = proporsal.user;
                        title = proporsal.title;
                        minVotes = minTokens;
                        maxVotes = maxVotess;
                        open = proporsal.open;
                        votersList = proporsal.votersList;
                        votes = {
                            yes = proporsal.votes.yes;
                            no = proporsal.votes.no;
                        };
                    };

                    proporsals.put(idPorposal , updateProporsal);
                    return #Ok(updateProporsal);
                };

            };
        }else {
            #Err("you dont have permissions");
        }
    };

    public func user_validation(user: Principal) : async Bool {
        let balance = await totalMbt();
        if(balance >= 1){
            true;
        }else {
            false;
        };
        
    };

    public shared({caller = user}) func vote(proposal_id : Id, vote : Bool) : async {#Ok : Text; #Err : Text} {
        let balance = await totalMbt();
        let proporsal: ?Proposal = proporsals.get(proposal_id);

        if(balance >= 1){
            switch(proporsal) {
                case(null) { return #Err("no exist") };

                case(?proporsal) { 
                    //check if the voter has vote in this porposal
                    let voted : ?Principal = List.find<Principal>(proporsal.votersList, func x = Principal.toText(x) == Principal.toText(user));
                    switch(voted){
                        case(null){};
                        case(voted){
                            return #Err("you already voted")
                        }
                    };
                    //check if porposal is open
                    if(proporsal.open == true){
                        var yesV: Nat = proporsal.votes.yes;
                        var noV: Nat = proporsal.votes.no;
                        var opens = true;

                        if(vote){
                            yesV += balance;
                        }else {
                            noV += balance;
                        };

                        let openOrNot: Nat = yesV - noV;

                        if(openOrNot < proporsal.maxVotes){
                            opens := true;
                        }else {
                            //webpage
                            opens := false;
                        };
                        let listVoterUpdate : List.List<Principal> = List.push(user, proporsal.votersList);

                        var updateProporsal: Proposal = {
                            user = proporsal.user;
                            title = proporsal.title;
                            minVotes = proporsal.minVotes;
                            maxVotes = proporsal.maxVotes;
                            votersList = listVoterUpdate;
                            open = opens;
                            votes = {
                                yes = yesV;
                                no = noV;
                            };
                        };

                        lastProposal := updateProporsal;
                        proporsals.put(proposal_id , updateProporsal);
                        return #Ok("Successfull Vote");
                    }else {
                        return #Err("The proposal is close");
                    };
                };

            };

        }else {
            #Err("You don't have MBT TOKENS");
        }

    };

    public query func get_proposal(id : Id) : async ?Proposal {
        proporsals.get(id);
    };
    
    public query func get_all_proposals() : async [(Id,Proposal)] {
       Iter.toArray<(Id,Proposal)>(proporsals.entries());
    };

    public shared (message) func whoami() : async Principal {
        return message.caller;
    };

    public func id() : async Principal {
        return await whoami();
    };

    system func preupgrade(){
        arraData := Iter.toArray<(Nat,Proposal)>(proporsals.entries());
    };

    system func postupgrade(){
        arraData := [];
    };


};