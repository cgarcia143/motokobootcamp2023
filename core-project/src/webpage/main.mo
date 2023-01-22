import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";
import Result "mo:base/Result";
import CertifiedData "mo:base/CertifiedData";

actor {
    public type HeaderField = (Text, Text);
    stable var titleText : Text = "Motoko 2022";
    
    public type StreamingStrategy = {
        #Callback: {
            callback : StreamingCallback;
            token    : StreamingCallbackToken;
        };
    };

    public type StreamingCallback = query (StreamingCallbackToken) -> async (StreamingCallbackResponse);

    public type StreamingCallbackToken =  {
        content_encoding : Text;
        index            : Nat;
        key              : Text;
    };

    public type StreamingCallbackResponse = {
        body  : Blob;
        token : ?StreamingCallbackToken;
    };

    type HttpResponse = {
        status_code: Nat16;
        headers: [HeaderField];
        body: Blob;
        streaming_strategy: ?StreamingStrategy;
    };

    type HttpRequest = {
        method: Text;
        url: Text;
        headers: [HeaderField];
        body: Blob;
    };

    let BadRequest : HttpResponse = {
        body = Text.encodeUtf8("Error: not found");
        headers = [("content-type", "text/plain") ];
        status_code = 404;
        streaming_strategy = null;
    };

    func main_(): Blob {
        return Text.encodeUtf8 (
        "<html><head><title>" # titleText # "</title></head><body>" # titleText # "</body></html>"
        )
    };

    public func update_Title(titles : Text) : async Result.Result<Text,Text>{
        try{
            titleText := titles;
            return #ok("Update successfull");
        }catch err{
            return #err("Failed update");
        };
    };

    private func removeQuery(str: Text): Text {
        return Option.unwrap(Text.split(str, #char '?').next());
    };

    public query func http_request(req : HttpRequest): async HttpResponse{

        let path = removeQuery(req.url);

        if(path == "/") {
            return {
                body = main_();
                headers = [("content-type", "text/html; charset=utf-8")];
                status_code = 200;
                streaming_strategy = null;
            };
        }else {
            return(BadRequest);
        }
        
    };


};
