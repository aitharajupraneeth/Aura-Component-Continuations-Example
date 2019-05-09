public class ContinuationHandler_AC {
    private static final String LONG_RUNNING_SERVICE_URL_1 = 'https://raw.githubusercontent.com/parthiban019/samplejson/master/candidateplaces.json';
    private static final String LONG_RUNNING_SERVICE_URL_2 = 'https://raw.githubusercontent.com/parthiban019/samplejson/master/customer.json';
    private static final String LONG_RUNNING_SERVICE_URL_3 = 'https://raw.githubusercontent.com/parthiban019/samplejson/master/student.json';
    
    public static CalloutWrapper.ResponseWrapper ResponseWrapperIns{get;set;}
    
    
    @AuraEnabled(continuation=true cacheable=true)
    public static Object startRequest() {
        
        Continuation con = new Continuation(40);
        con.continuationMethod='processResponse';
        con.state='Continuation State';
        
        
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setEndpoint(LONG_RUNNING_SERVICE_URL_1);
        con.addHttpRequest(req1);
        
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        req2.setEndpoint(LONG_RUNNING_SERVICE_URL_2);
        con.addHttpRequest(req2);
        
        HttpRequest req3 = new HttpRequest();
        req3.setMethod('GET');
        req3.setEndpoint(LONG_RUNNING_SERVICE_URL_3);
        con.addHttpRequest(req3);
        return con;
    }
    
    @AuraEnabled(cacheable=true)
    public static Object processResponse(List<String> labels, Object state) {
        
        CalloutWrapper.ResponseWrapper ResponseWrapperIns = new CalloutWrapper.ResponseWrapper();
        
        HttpResponse response1 = Continuation.getResponse(labels[0]);
        if(response1.getBody() != null && response1.getStatusCode() == 200){
            ResponseWrapperIns.candidateWrapperList = (List<CalloutWrapper.CandidateWrapper>)json.deserialize(response1.getBody(),List<CalloutWrapper.CandidateWrapper>.class);
        }
        
        HttpResponse response2 = Continuation.getResponse(labels[1]);
        if(response2.getBody() != null && response2.getStatusCode() == 200){
            ResponseWrapperIns.customerWrapperList = (List<CalloutWrapper.CustomerWrapper>)json.deserialize(response2.getBody(),List<CalloutWrapper.CustomerWrapper>.class);
        }
        
        HttpResponse response3 = Continuation.getResponse(labels[2]);
        if(response3.getBody() != null && response3.getStatusCode() == 200){
            ResponseWrapperIns.studentWrapperList = (List<CalloutWrapper.StudentWrapper>)json.deserialize(response3.getBody(),List<CalloutWrapper.StudentWrapper>.class);
        }
        
        return json.serialize(ResponseWrapperIns);
    }
}