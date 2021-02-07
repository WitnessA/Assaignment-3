import ballerina/io;
import ballerina/http;
import ballerina/graphql;

function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream");
    }
}

function read(string path) returns @tainted json|error {

    io:ReadableByteChannel rbc = check io:openReadableFile(path);

    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var result = rch.readJson();
    closeRc(rch);
    return result;
}

string filePath = "C:/Users/witma/Desktop/Desktop Files/Assignment 3/applicants.json";

http:Listener httpListener = new(8080);

service graphql:Service /graphql on new graphql:Listener(httpListener) {

    resource function read application(int studentNo)returns json|error? {

         var rResult = read(filePath);
        if (rResult is error) {
            log:printError("Error occurred while reading json: ");
        } else {
            io:println(rResult.toJsonString());
        }
        json|error j = json.constructFrom(rResult);
        json j1 =<json> j;
        if(j.studentNo == studentNo){
            return j;
        }
    }

    }
}