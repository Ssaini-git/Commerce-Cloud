public class StripeAllCreditCards {
    @AuraEnabled
    public static  list<StripeCreditCardWrapper.CreditCards> getCards(String OrderId){
        System.debug('==OdrId>'+OrderId);
         List<Order> odrList;
         list<StripeCreditCardWrapper.CreditCards> wrapper = new  list<StripeCreditCardWrapper.CreditCards>();
        if(OrderId !=null){ 
        odrList = [SELECT Id,accountId,account.name,account.email__c,account.phone,account.Stripe_Customer_Id__c FROM Order WHERE Id =:OrderId];
        }
        if(odrList[0].account.Stripe_Customer_Id__c !=null){
        try{
            //  PaymentAuthorization  obj = [Select id,GatewayAuthCode from PaymentAuthorization where order__c  ='8018G000000SQIBQA4' limit 1];
            HTTP objectOfHttp = new HTTP();
            HTTPRequest req = new HTTPRequest();
            req.setEndpoint('https://devboomi.imprimisrx.com:9090/ws/simple/getAllCreditCards');
            req.setMethod('POST');  
            String JSONBody = '{"customerId":"'+odrList[0].account.Stripe_Customer_Id__c+'","limit":"6"}';
            req.setBody(JSONBody);
            integer StatusCode = 0;  
              HTTPResponse res =new HTTPResponse();            if(!Test.isRunningTest()){           res = objectOfHttp.send(req);
                StatusCode =res.getStatusCode();            }else{               StatusCode=200;             }
            if(res.getStatusCode() == 200){                String responseBody = res.getBody();
                System.debug('responseBody===>'+responseBody);
                StripeCreditCardWrapper wrapperObj = StripeCreditCardWrapper.parse(responseBody);
                system.debug('===>wrapperObj'+wrapperObj.cardsList);
                return wrapperObj.cardsList;            }
            System.debug('RESPONSE '+res);
            System.debug('RESPONSE >>body>>'+res.getBody()); 
            return wrapper;        }
        catch(Exception eObj){            System.debug('-->'+eObj);            return wrapper;        }
           
        }
        else{
            System.debug('==>No Customer Id Avaialble');
            return wrapper; 
        }
    }
    
}