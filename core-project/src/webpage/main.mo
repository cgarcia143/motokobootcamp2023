import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Option "mo:base/Option";

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
        headers = [];
        status_code = 404;
        streaming_strategy = null;
    };

    private func update_Title(t : ?Text) : (){
        titleText := Option.get(t , titleText);
    };

    public query func http_request(req : HttpRequest): async HttpResponse{
        switch(req.method){
            case("GET"){
                return({
                    body = Text.encodeUtf8(titleText);
                    headers = [];
                    status_code = 200;
                    streaming_strategy = null;
                });
            };
            case(_){
                return(BadRequest);
            }
        }
    };


};
