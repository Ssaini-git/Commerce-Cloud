@RestResource(urlMapping='/stripeExpirePreAuth')
global with sharing class StripeWebhookCallout {
	@HttpPost
    global static String doPost() {
        String requestBody = RestContext.request.requestBody.toString();
        Map<String, Object> req = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        if(!req.keySet().contains('data')){
			return 'Data Not Found';            
        }
        Map<String, Object> data = (Map<String, Object>) req.get('data');
        if(!data.keySet().contains('object')){
			return 'object Not Found';            
        }
    	Map<String, Object> object_Z = (Map<String, Object>) data.get('object');
        try{
            PaymentAuthorization pa = [SELECT Id, GatewayAuthCode FROM PaymentAuthorization WHERE GatewayAuthCode like :(String)object_Z.get('id')];
        	pa.GatewayAuthCode = '';
            update pa;
            return (String)object_Z.get('id');
        }catch(Exception e){
            return (String)object_Z.get('id');
        }
       
      	
    }
}