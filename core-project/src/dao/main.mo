import HashMap "mo:base/HashMap";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
actor {

    type Proposal = {
        user: Principal;
        title: Text;
        minVotes: Nat;
        maxVotes: Nat;
        votes: {
            yes: Nat;
            no: Nat; 
        };
    };

    type Id = Nat;  
    // TO DEFINE;
    stable var arraData: [(Id,Proposal)] = [];
    var proporsals = HashMap.fromIter<Id, Proposal>(arraData.vals(),1, Nat.equal, Hash.hash);
    stable var postIdCount: Id = 0;

    let nameToken : actor { icrc1_name  : () -> async Text } = actor ("db3eq-6iaaa-aaaah-abz6a-cai"); 
    let accountBalanceMBT : actor { icrc1_balance_of  : ({owner:Principal; subaccount: ?[Nat8]}) -> async Nat } = actor ("db3eq-6iaaa-aaaah-abz6a-cai"); 

    public func nameMbt() : async Text {
        let name: Text = await nameToken.icrc1_name();
        return name;
    };

    public shared({caller = user}) func totalMbt() : async Nat {
        let total: Nat = await accountBalanceMBT.icrc1_balance_of({owner=user; subaccount=null});
        return total;
    };


    public shared({caller = usuario}) func submit_proposal(this_payload : Text) : async {#Ok : Proposal; #Err : Text} {
        let id: Id = postIdCount;
        postIdCount+=1;

        var createProposal: Proposal = {
            user = usuario;
            title = this_payload;
            minVotes = 1;
            maxVotes = 100;
            votes = {
                yes = 0;
                no = 0;
            };
        };

        proporsals.put(id, createProposal);

        #Ok(createProposal);
    };

    public func user_validation(user: Principal) : async Bool {
        let balance = await totalMbt();
        if(balance >= 1){
            true;
        }else {
            false;
        };
        
    };

    public shared({caller = user}) func vote(proposal_id : Id, vote : Bool) : async {#Ok : (Nat, Nat); #Err : Text} {
        if(user_validation(user) == true){
            
            let proporsal: ?Proposal = proporsals.get(proposal_id);
            let balance = await totalMbt();

                switch(proporsal) {
                    case(null) { return #Err("no exist") };

                    case(?proporsal) { 
    
                        var yesV: Nat = proporsal.votes.yes;
                        var noV: Nat = proporsal.votes.no;

                        if(vote){
                            yesV += balance;
                        }else {
                            noV += balance;
                        };

                        var updateProporsal: Proposal = {
                            user = proporsal.user;
                            title = proporsal.title;
                            minVotes = proporsal.minVotes;
                            maxVotes = proporsal.maxVotes;
                            votes = {
                                yes = yesV;
                                no = noV;
                            };
                        };

                        proporsals.put(proposal_id , updateProporsal);

                    };
                };


        }else {
            return #Err("Not work");
        };

       return #Err("Not implemented yet");
    };

    public query func get_proposal(id : Id) : async ?Proposal {
        proporsals.get(id);
    };
    
    public query func get_all_proposals() : async [(Id,Proposal)] {
       Iter.toArray<(Id,Proposal)>(proporsals.entries());
    };

};