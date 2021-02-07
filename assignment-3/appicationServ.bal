
import ballerina/graphql;
import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/docker;

function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream");
    }
}

function write(json content, string path) returns @tainted error? {

    io:WritableByteChannel wbc = check io:openWritableFile(path);

    io:WritableCharacterChannel wch = new (wbc, "UTF8");
    var result = wch.writeJson(content);
    closeWc(wch);
    return result;
}

string filePath = "C:/Users/witma/Desktop/Desktop Files/Assignment 3/applicants.json";

@docker:Config{}
http:Listener httpListener = new(9090);

service graphql:Service /graphql on new graphql:Listener(httpListener) {

    resource function post application(json j) {

        var wResult = write(j, filePath);
        if (wResult is error) {
        log:printError("Error occurred while writing json: ");
    }

    }
}


