public class StripeCreditCardWrapper {
     public list<CreditCards> cardsList{get;set;}
     public StripeCreditCardWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					 if (text == 'data') {
						cardsList = arrayOfData(parser);
					}else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
     private static List<CreditCards> arrayOfData(System.JSONParser p) {
        List<CreditCards> res = new List<CreditCards>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CreditCards(p));
        }
        return res;
    }
     public static StripeCreditCardWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new StripeCreditCardWrapper(parser);
	}
     public class CreditCards{
         @auraEnabled
		public String id {get;set;} 
         @auraEnabled
		public Integer exp_month {get;set;} 
         @auraEnabled
		public Integer exp_year {get;set;} 
         @auraEnabled
		public String last4 {get;set;} 
        @auraEnabled
		public String brand {get;set;} 
         
         
		public CreditCards(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'exp_month') {
							exp_month = parser.getIntegerValue();
						} else if (text == 'exp_year') {
							exp_year = parser.getIntegerValue();
						} else if (text == 'last4') {
							last4 = parser.getText();
						}else if (text == 'brand') {
							brand = parser.getText();
						}
                        else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
     public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
}