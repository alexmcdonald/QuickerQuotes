public with sharing class QQ_SearchPricebookEntries {
    
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLines(String quoteId) {
        List<QuoteLineItem> qlis = [SELECT Id, PricebookEntryId, PricebookEntry.UnitPrice, Product2Id, Product2.Name, Product2.ProductCode, Quantity, UnitPrice, Discount FROM QuoteLineItem WHERE QuoteId = :quoteId ORDER BY LineNumber ASC];
        return qlis;
    }


    @AuraEnabled
    public static Integer getTotalPricebookEntryCount(String keyword, String pricebookId) {
        if(keyword != null && keyword != '') {
    	    return [SELECT Count() FROM PricebookEntry WHERE (Name LIKE :('%'+keyword+'%') OR ProductCode LIKE :('%'+keyword+'%')) AND Pricebook2Id=:pricebookId AND IsActive=TRUE];        
        } else {
            return [SELECT Count() FROM PricebookEntry WHERE Pricebook2Id=:pricebookId AND IsActive=TRUE];
        }
    }
    
    @AuraEnabled
    public static Response getResults(String keyword, String pricebookId) {
        List<PricebookEntry> output = [SELECT Id, Name, ProductCode, Product2.Family, UnitPrice FROM PricebookEntry WHERE (Name LIKE :('%'+keyword+'%') OR ProductCode LIKE :('%'+keyword+'%')) AND IsActive=TRUE AND Pricebook2Id=:pricebookId LIMIT 20];
        Response r = new Response();
        r.records = output;
        r.count = output.size();
        return r;
    }
    
	@AuraEnabled(cacheable=true)
    public static Response getPricebookEntries(String keyword, String pricebookId, Integer offset, Integer resultLimit) {
        List<PricebookEntry> output = new List<PricebookEntry>();
        if(keyword != null && keyword != '') {
            output = [SELECT Id, Name, ProductCode, Product2.Family, UnitPrice FROM PricebookEntry WHERE (Name LIKE :('%'+keyword+'%') OR ProductCode LIKE :('%'+keyword+'%')) AND IsActive=TRUE AND Pricebook2Id=:pricebookId ORDER BY Name ASC LIMIT :resultLimit OFFSET :offset];
        } else {
            output = [SELECT Id, Name, ProductCode, Product2.Family, UnitPrice FROM PricebookEntry WHERE IsActive=TRUE AND Pricebook2Id=:pricebookId ORDER BY Name ASC LIMIT :resultLimit OFFSET :offset];
        }
        Response r = new Response();
        r.records = output;
        r.count = output.size();
        r.totalCount = getTotalPricebookEntryCount(keyword, pricebookId);
        return r;
    }
    
    public class Response {
        @AuraEnabled public List<PricebookEntry> records;
        @AuraEnabled public Integer count;
        @AuraEnabled public Integer totalCount;

    }
    
}