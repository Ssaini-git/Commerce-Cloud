public class StripeAddCreditCardController {
    @AuraEnabled
    public static String addCardToStripe(String odrId,StripeAddCreditCardController.CardDetails card){
        List<Order> odrList = [SELECT Id,accountId,account.name,account.email__c,account.phone,account.Stripe_Customer_Id__c,Stripe_Authorization_Token__c FROM Order WHERE Id =:odrId];
        if(((card.CardNumber!=null && card.CardNumber!='') ||(card.OwnerName!=null && card.OwnerName !='')||(card.CVC!=null && card.CVC!='')||(card.Month!=null &&card.Month!='')||(card.Year!=null &&card.Year!='') && odrList.size()>0)){
            if(odrList[0].account.Stripe_Customer_Id__c !=null){
                try{
                    HTTP objectOfHttp = new HTTP();
                    HTTPRequest req = new HTTPRequest();
                    req.setEndpoint('https://devboomi.imprimisrx.com:9090/ws/simple/createCard');
                    req.setMethod('POST');  
                    String JSONBody ='{"source":{"object":"card","number":"'+card.CardNumber.deleteWhitespace()+'","exp_month":"'+card.Month+'","exp_year":"'+card.Year+'","cvc":"'+card.CVC+'","name":"'+card.OwnerName.deleteWhitespace()+'"},"customerId":"'+odrList[0].account.Stripe_Customer_Id__c+'"}';
                    System.debug('===>'+JSONBody);
                    req.setBody(JSONBody);
                    integer StatusCode = 0; 
                    String responseBody='';
                    HTTPResponse res =new HTTPResponse();
                    if(!Test.isRunningTest()){    
                        res = objectOfHttp.send(req);
                        StatusCode=res.getStatusCode(); 
                        responseBody = res.getBody();
                    } else{ StatusCode=200; responseBody='{"id": "card_1MHkl4EFThUnqZRX5YMJa1tE", "object": "card", "address_city": null, "address_country": null, "address_line1": null, "address_line1_check": null, "address_line2": null, "address_state": null, "address_zip": null, "address_zip_check": null, "brand": "Visa", "country": "US", "customer": "cus_MyZmd9zTfQhtwG", "cvc_check": "pass", "dynamic_last4": null, "exp_month": 12, "exp_year": 2025, "fingerprint": "lJkjGTIHXNAFN3cm", "funding": "credit", "last4": "4242", "metadata": {}, "name": "pawan", "tokenization_method": null }';}
                    if(StatusCode == 200){
                        Error errorObj = new Error();
                        Map<String,Object> respData = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
                        String cardId = (String) respData.get('id');
                        String cardType = (String) respData.get('brand');
                        if(cardId ==null){ String jsonString = Json.serialize(respData.get('error'));
                            errorObj =(Error)JSON.deserialize(jsonString,Error.class);
                            System.debug('=respData.get==>'+errorObj);
                            if(errorObj.message !=null){return errorObj.message; }
                        }
                        try{
                            if(cardId !=null){ CardPaymentMethod  obj = new CardPaymentMethod();
                                obj.Status ='active';
                                obj.Account__c=odrList[0].AccountId;
                                obj.ProcessingMode ='External';
                                obj.ExpiryMonth =Integer.valueOf(card.Month);
                                obj.ExpiryYear =Integer.valueOf(card.Year);
                                obj.CardHolderName = card.OwnerName;
                                obj.InputCardNumber =card.CardNumber.deleteWhitespace();
                                insert obj;
                                system.debug('--kkkk> '+obj.Id);
                                return 'true';
                            } return 'Card Error !';
                        } catch(Exception e){ return 'false';} }return 'Server Error !';       
                } catch(Exception e){return 'false'; }  
            } else{ return 'Please Create Customer !';}
        }else{ return 'Please Enter The Card Details Correctly !'; }
    }
    @AuraEnabled
    public static String removeCardFromStripe(String OrderId,String SourceId){
        List<Order> odrList = [SELECT Id,accountId,account.name,account.email__c,account.phone,account.Stripe_Customer_Id__c,Stripe_Authorization_Token__c FROM Order WHERE Id =:OrderId];
        if(odrList[0].account.Stripe_Customer_Id__c !=null){
            try{
                HTTP objectOfHttp = new HTTP();
                HTTPRequest req = new HTTPRequest();
                req.setEndpoint('https://devboomi.imprimisrx.com:9090/ws/simple/createCard');
                req.setMethod('POST');  
                String JSONBody ='{"sourceId":"'+sourceId+'","customerId":"'+odrList[0].account.Stripe_Customer_Id__c+'"}';
                System.debug('===>'+JSONBody);
                req.setBody(JSONBody);
                integer StatusCode = 0; 
                String responseBody='';
                HTTPResponse res =new HTTPResponse();
                if(!Test.isRunningTest()){ res = objectOfHttp.send(req);
                    StatusCode=res.getStatusCode(); 
                    responseBody = res.getBody();
                    System.debug('Sharma===responseBody>'+responseBody);
                    System.debug('===>'+StatusCode);
                }else{StatusCode=200; responseBody='Content-Type: application/json{ "id": "card_1MEcePEFThUnqZRXNPzfrL6o", "object": "card", "deleted": true }';}
                if(StatusCode == 200){                    Error errorObj = new Error();
                    RemoveCard delObj = new RemoveCard();
                    System.debug('==>'+json.serialize(responseBody));
                    string str = responseBody.substringAfter('json');
                    System.debug('==>'+str);
                    sTRING ST =json.serialize(responseBody);
                    System.debug('==>'+json.deserializeUntyped(str));
                   delObj = (StripeAddCreditCardController.RemoveCard) JSON.deserialize(str, StripeAddCreditCardController.RemoveCard.class);
                    System.debug('==>'+str);
                    system.debug('=delObj=>'+delObj);
                   if(delObj.deleted==null || delObj.deleted ==false){  Map<String,Object> respData = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
                        String jsonString = Json.serialize(respData.get('error'));
                        errorObj =(Error)JSON.deserialize(jsonString,Error.class);
                        System.debug('=respData.get==>'+errorObj);
                        if(errorObj.message !=null){  return errorObj.message;    }  }
                    else{return 'true';} 
                    return 'true';  }
                system.debug('==>'+StatusCode);
                return 'false';        
            }
            catch(Exception e){return 'false';}  
        }        return 'Apex Error !';    }
    public class CardDetails{
        @AuraEnabled
        public String OwnerName{get;set;}
        @AuraEnabled
        public String CardNumber{get;set;}
        @AuraEnabled
        public String CVC{get;set;}
        @AuraEnabled
        public String Month{get;set;}
        @AuraEnabled
        public String Year{get;set;}    }
    public class Error{
        @AuraEnabled
        public String code{get;set;}
        @AuraEnabled
        public String message{get;set;}
        @AuraEnabled
        public String type{get;set;}    }
    public class RemoveCard{
        public String object1{get;set;}
        public Boolean deleted{get;set;}
        public String id{get;set;}    }
}