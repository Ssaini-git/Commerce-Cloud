public class StripeRemoveCardHandler {
	public String id;	//card_1M55HbEFThUnqZRXBEHDidCO
	public String object1;	//card
	public boolean deleted;
	public static StripeRemoveCardHandler parse(String json){
        system.debug('======pk====>'+json);
		return (StripeRemoveCardHandler) System.JSON.deserialize(json, StripeRemoveCardHandler.class);
	}
}