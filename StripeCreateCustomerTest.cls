@isTest
public class StripeCreateCustomerTest {
      static testMethod void testPost() {
          Account acc = new Account();
          acc.name ='test';
          acc.Email__c='test@gmail.com';
          acc.Phone='123456789';
          acc.Type='Patient';
          insert acc;
          Order od=new order();
          od.AccountId=acc.Id;
          od.EffectiveDate=system.today();
          od.Status='Draft';
          insert od;
          system.debug(od.Id);
          StripeCreateCustomerController.createCustomer(od.Id);
          StripeCreateCustomerController.userProfileAccess();
          
      }
    
}