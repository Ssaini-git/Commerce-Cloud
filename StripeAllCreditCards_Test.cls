@isTest
public class StripeAllCreditCards_Test {
      static testMethod void testPost() {
          Account acc = new Account();
          acc.name ='test';
          acc.Email__c='test@test.com';
          acc.Stripe_Customer_Id__c='rerer';
          insert acc;
          Order od=new order();
          od.AccountId=acc.Id;
          od.EffectiveDate=system.today();
          od.Status='Draft';
          insert od;
          system.debug(od.Id);
          StripeAllCreditCards.getCards(od.Id);
      }

}