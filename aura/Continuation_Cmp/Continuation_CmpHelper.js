({
    callContinuation : function(component, event, helper) {
        var action = component.get("c.startRequest");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state -->  '+state);
            
            if (state === "SUCCESS") {
                console.log("From server: "+ response.getReturnValue());
                var respVal = JSON.parse(response.getReturnValue());
                if(respVal != null && respVal.candidateWrapperList != null){
                    component.set("v.candidateList",respVal.candidateWrapperList);
                }
                if(respVal != null && respVal.customerWrapperList != null){
                    component.set("v.customerList",respVal.customerWrapperList);
                }
                if(respVal != null && respVal.studentWrapperList != null){
                    component.set("v.studentList",respVal.studentWrapperList);
                }
            } else {
            }
        });
        $A.enqueueAction(action);
    }
})