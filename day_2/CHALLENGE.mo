import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";

actor {

  public query func average_array(array : [Nat]) : async Int {
    var s : Int = 0;
    for (number in array.vals()) {
      s += number;
    };

    return s
  
  };

  public query func count_character(t: Text, c: Char) : async Nat {
    var s : Nat = 0;
    for (string in Text.toIter(t)) {
      if(string == c){
          s := s + 1;
      };
    };

    return s
  
  };

  public query func factorial (n: Nat) : async Nat {
    var n : Nat = 0;
    var count : Nat = 0;
    loop {
      count += 1;
      n += count;
      if(count >= n) {
        return n;
      }
    }
  };

  public query func number_of_words (text: Text) : async Nat {
    let w = Text.split(text, #char ' ');
    return Iter.size<Text>(w);
  };

};