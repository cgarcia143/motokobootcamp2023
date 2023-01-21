import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Nat32 "mo:base/Nat32";

actor {
  type Book = {
    user: Principal;
    title: Text;
    description: Text;
  };
  type Id = Nat32;
  stable var arraData: [(Id,Book)] = [];
  var books = HashMap.fromIter<Id, Book>(arraData.vals(), 1 , Nat32.equal, func (a : Nat32) : Nat32 {a});
  stable var postIdCount: Id = 0;

  public func createBook (book : Book): async  Text {


    let id: Id = postIdCount;
    postIdCount+=1;

    books.put(id, book);

    return "Success Create Book";

  };

  public func updatePost ( book: Book, id: Id): async Text {

    let bookGet: ?Book = books.get(id);

    switch(bookGet) {
      case(null) {  
        return "No Actualizado"
      };
      case(?currentBook) {
        let updateBook : Book = {
          user = currentBook.user;
          title = book.title;
          description = book.description;
        };  

        books.put(id, updateBook);
        return "Success update"
      };
    };

  };

  public func removeBook ( book: Book, id: Id): async Text {

    let bookGet: ?Book = books.get(id);

    switch(bookGet) {
      case(null) {  
        return "No se ha encontrado"
      };
      case(_) {
        ignore books.remove(id);
        return "Eliminado Correctamente"
      };
    };

  };

  public query func readBook (id: Id): async ?Book {
    let bookRes: ?Book = books.get(id);

    return bookRes;
  };

  public query func listBooks () : async [(Id,Book)] {
    Iter.toArray(books.entries());
  };

  system func preupgrade(){
    arraData := Iter.toArray<(Id, Book)>(books.entries()) 
  };

  system func postupgrade(){
    arraData := [];
  };

};