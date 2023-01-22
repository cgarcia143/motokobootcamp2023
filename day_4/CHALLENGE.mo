import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";

actor {

    public query ({ caller }) func is_anynomous() : async Bool {
        Principal.isAnonymous(caller);
    };

    let users = HashMap.HashMap<Principal, Text>(0, Principal.equal, Principal.hash);
    
    public query func get_usernames() : async [(Principal, Text)] {
        Iter.toArray(users.entries());
    };

};