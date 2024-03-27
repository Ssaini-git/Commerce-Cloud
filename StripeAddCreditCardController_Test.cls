@isTest
public class StripeAddCreditCardController_Test {
 static testMethod void testPost() {
       Account Acc=new Account();
    Acc.Name='test';
    Acc.Email__c='test@test.com';
     Acc.Stripe_Customer_Id__c='test';
    insert Acc;
    order ord=new order();
    ord.Type='Patient';
    ord.AccountId=Acc.Id;
    ord.Status='Draft';
   ord.EffectiveDate=system.today();
    insert ord;
 StripeAddCreditCardController.CardDetails card  = new StripeAddCreditCardController.CardDetails();
    card.CardNumber='1234';
     card.Month='4';
     card.Year='2020';
     card.CVC='123';
     card.OwnerName='Pawan';
     StripeAddCreditCardController.removeCardFromStripe(ord.id,'test');
     StripeAddCreditCardController.addCardToStripe(ord.id,card);
     StripeAddCreditCardController.CardDetails obj=new StripeAddCreditCardController.CardDetails();
  
        }
   public static testMethod void testPost1() {
        Account Acc=new Account();
    Acc.Name='test';
    Acc.Email__c='test@test.com';
    insert Acc;
    order ord=new order();
    ord.Type='Patient';
    ord.AccountId=Acc.Id;
    ord.Status='Draft';
   ord.EffectiveDate=system.today();
    insert ord;
        StripeAddCreditCardController.CardDetails card  = new StripeAddCreditCardController.CardDetails();
     StripeAddCreditCardController.addCardToStripe(ord.Id,card);
    StripeAddCreditCardController.removeCardFromStripe(ord.Id,'test');
       StripeAddCreditCardController.Error er= new StripeAddCreditCardController.Error();
       er.code='error';
           er.message='error';
           er.type='error';
       StripeAddCreditCardController.RemoveCard remov= new StripeAddCreditCardController.RemoveCard();
       remov.deleted=true;
       remov.id='test';
           remov.object1='test';
        }
    public static testMethod void testPost2() {
        StripeAddCreditCardController.CardDetails card  = new StripeAddCreditCardController.CardDetails();
     StripeAddCreditCardController.addCardToStripe('ord.Id',card);
  //  StripeAddCreditCardController.removeCardFromStripe('ord.Id','test');
        }
}