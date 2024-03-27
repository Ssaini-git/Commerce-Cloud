public class StripeCreateCustomerController {
    @AuraEnabled
    public static boolean createCustomer(String odrId){
        //  PaymentAuthorization  obj = [Select id,GatewayAuthCode from PaymentAuthorization where order__c  ='8018G000000SQIBQA4' limit 1];
        List<Order> odrList = [SELECT Id,accountId,account.name,account.type, account.email__c,account.phone,account.Stripe_Customer_Id__c FROM Order WHERE Id =:odrId];
        if(odrList[0].account.type =='Prescriber' ||odrList[0].account.type=='Patient' || odrList[0].account.type == 'Facility' ||odrList[0].account.type =='Facility-Prospect'){
            if((odrList[0].account.Stripe_Customer_Id__c =='' || odrList[0].account.Stripe_Customer_Id__c ==null)){
                try{
                    Account accObj =[Select id,email__c,phone,Stripe_Customer_Id__c,Balance__c from Account where id=:odrList[0].accountId limit 1];
                    if (accObj.Balance__c==null){
                        accObj.Balance__c = 0 ; } 
                    Integer myintval = Integer.valueOf(accObj.Balance__c);
                    HTTP objectOfHttp = new HTTP();
                    HTTPRequest req = new HTTPRequest();
                    req.setEndpoint('https://devboomi.imprimisrx.com:9090/ws/simple/createCustomer');
                    req.setMethod('POST');  
                    String JSONBody = '{"email" : "'+accObj.email__c+'" ,"name":"'+odrList[0].account.name.deleteWhitespace()+'","phone":"'+accObj.phone+'","balance":"'+myintval +'"}';
                    System.debug('==>json>>'+JSONBody);
                    req.setBody(JSONBody);
                    HTTPResponse res =new HTTPResponse();
                    integer StatusCode = 0;
                    string responseBody='';
                    if(!Test.isRunningTest()){          
                        res = objectOfHttp.send(req);         
                        StatusCode = res.getStatusCode();
                    }
                    else{StatusCode = 200;}                
                    if(StatusCode == 200){   
                        if(Test.isRunningTest()){
                           responseBody= '{"email" : "test@gmail.com" ,"name":"test","phone":"123456789","balance":"0"}';
                        }else{ responseBody = res.getBody();}
                        Map<String,Object> respData = (Map<String,Object>) JSON.deserializeUntyped(responseBody);
                        String custId = (String) respData.get('id');                
                        accObj.Stripe_Customer_Id__c = custId;                 
                        update accObj;
                        return true;         
                    } 
                    return false;  
                }          
                catch(Exception e){  return false;  }
            }
            else   return false;
        }
        else{   return false;  }
    }
    @AuraEnabled
    public static boolean userProfileAccess(){
        set<string> profileAccess = new set<string>{'Accounting','Internal Sales/Customer Care','Customer Care Manager','System Administrator'};
            string currentUser = UserInfo.getProfileId();
        Profile  profiles  = [select Id, Name FROM Profile where id =: currentUser limit 1 ];
        if(profileAccess.contains(profiles.Name)){ return true;} else{ return false;  }
    }
}