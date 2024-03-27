public class StripeStorePreAuthorizationToken {
    public static String getAutorizationToken(String OrderId,String cardId){
        try{
            System.debug('===@OrderId@@==>'+OrderId);
            System.debug('===@cardId@@==>'+cardId);
            PaymentAuthorization  obj = new PaymentAuthorization();
            List<Order> odrList;
            if(OrderId !=null && cardId !=null) {    odrList = [SELECT Id,accountId,Order_Total__c,account.name,account.Id,account.email__c,Stripe_Authorization_Token__c,account.phone,account.Stripe_Customer_Id__c FROM Order WHERE Id =:OrderId];
                HTTP objectOfHttp = new HTTP();
                HTTPRequest req = new HTTPRequest();
                req.setEndpoint('https://devboomi.imprimisrx.com:9090/ws/simple/createCharge');
                req.setMethod('POST'); 
                String JSONBody = '{"amount":"'+Integer.valueOf(odrList[0].Order_Total__c) *100+'","currency":"usd","customer":"'+odrList[0].account.Stripe_Customer_Id__c+'","source":"'+cardId+'","capture":"false"}';
                req.setBody(JSONBody);
                integer StatusCode = 0; 
                  String responseBody='';
                System.debug('==@JSONBody@==>'+JSONBody);
                HTTPResponse res =new HTTPResponse();
                if(!Test.isRunningTest()){   
                    res = objectOfHttp.send(req);
                    StatusCode=res.getStatusCode();
                    responseBody = res.getBody();
                }else{
                    StatusCode=200;
                     responseBody='{ "error": { "code": "missing", "doc_url": "https://stripe.com/docs/error-codes/missing", "message": "Customer cus_MyZmd9zTfQhtwG does not have a linked source with ID cus_MyZmd9zTfQhtwG.", "param": "source", "request_log_url": "https://dashboard.stripe.com/test/logs/req_gLiA7oAbvFjIMB?t=1671691904", "type": "invalid_request_error" } }';
                }
                if( StatusCode == 200){
                    System.debug('==responseBody>'+responseBody);
                    Map<String,Object> respData = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
                    String chargeId = (String) respData.get('id');
                    if(chargeId !=null){
                        obj.GatewayAuthCode = chargeId;
                        obj.Amount =Integer.valueOf(odrList[0].Order_Total__c);
                        obj.accountId =odrList[0].account.id;
                        obj.Status ='Processed';
                        obj.ProcessingMode ='External';
                        obj.Order__c =OrderId;
                        insert obj;
                        return 'true';
                    }
                    else{
                        obj.GatewayAuthCode = chargeId;
                        obj.Amount =Integer.valueOf(odrList[0].Order_Total__c);
                        obj.ProcessingMode ='External';
                        obj.accountId =odrList[0].account.id;
                        obj.Order__c =OrderId;
                        obj.Status ='Failed';
                        insert obj;  
                        return 'false';
                    } }
                else{ return 'false';  }   }
            else{ return 'false'; }  }
        catch(Exception eObj){return 'false'; }
    }}