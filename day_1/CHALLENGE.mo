actor {
    
    public func multiply(n : Nat, m: Nat) : async Nat {
        return n * m;
    };

    public func volume(n : Nat) : async Nat {
        return n * n * n ;
    };
    
    public func hours_to_minutes(n : Nat) : async Nat {
        return n * 60 ;
    };

    var counter : Nat = 0;

    public func set_counter(n : Nat) : async () {
        counter := n; 
    };

    public func get_counter() : async Nat {
        return counter;
    };

    public func test_divide(n : Nat, m: Nat) : async Bool {
       return n % m == 0;
    };

    public func is_even(n : Nat) : async Bool {
        return n % 2 == 0;
    };

};