public with sharing class QQ_SearchPricebookEntries {
    
    @AuraEnabled
    public static Response getResults(String keyword, String pricebookId) {
        List<PricebookEntry> output = [SELECT Id, Name, ProductCode, Product2.Family, UnitPrice FROM PricebookEntry WHERE (Name LIKE :('%'+keyword+'%') OR ProductCode LIKE :('%'+keyword+'%')) AND IsActive=TRUE AND Pricebook2Id=:pricebookId];
        Response r = new Response();
        r.records = output;
        r.count = output.size();
        return r;
    }
    
    public class Response {
        @AuraEnabled public List<PricebookEntry> records;
        @AuraEnabled public Integer count;
    }

}