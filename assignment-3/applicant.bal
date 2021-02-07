import ballerina/http;
import ballerina/docker; 


public client class Client {
    private http:Client httpClient;

    public function init(string url)returns ClientError? {
        http:Client|error httpClient = new(url);
        if(httpClient is error){
            return error initializationError("Error occured while creating client endpoint");
        }else{
            self.httpClient = httpClient;
        }
    }
}

remote function query(string document, string? operationName = ())returns @tainted json|ClientError{
    map<json> payload = {
        query: document
    };

    if(operationName is string){
        payload[operationName] = operationName;
    }

    http:Request request = new;
    request.setPayload(payload);
    var result = self.httpClient->post("/", request,json);
    if(result is error){
        string message = "Error";
        return error ConnectionError(message, result);
    }else{
        return<json>result;
    }
}