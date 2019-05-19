global with sharing class ExchangeRateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    private Map<String, Exchange_Rate__c> populateExchangeRates(List<Expense_Item__c> expenseItems) {
        Map<Date, Set<String>> expenseMap = new Map<Date, Set<String>>();
        List<Exchange_Rate__c> allExchangeRates = new List<Exchange_Rate__c>();
        Map<String, Exchange_Rate__c> exchangeRateMap = new Map<String, Exchange_Rate__c>();

        for (Expense_Item__c itemObj : expenseItems){ 
            Date expenseItemDate = itemObj.Date__c;

            Set<String> currencies = expenseMap.get(expenseItemDate);

            if (currencies == null) {
                currencies = new Set<String>();
            }

            currencies.add(itemObj.Currency__c);
            expenseMap.put(expenseItemDate, currencies);
        }

        for (Date key : expenseMap.keySet()) {
            List<String> currencyList =  new List<String>(expenseMap.get(key));
            ExchangeRateService service = new ExchangeRateService(key, currencyList);
            allExchangeRates.addAll(service.getFXRates());
        }
        for (Exchange_Rate__c exchangeRate : allExchangeRates) {
            String dateCurrencyKey = exchangeRate.Rate_Date__c + ':' + exchangeRate.Currency__c;
            exchangeRateMap.put(dateCurrencyKey, exchangeRate);
        }

        /*{
            '2019-05-09:JPY' : {Rate_Date__c: '2019-05-09', Currency__c : 'JPY', Exchange_Rate__c: 1.8989},
            '2019-05-09:USD' : {},
            '2019-05-11:USD' : {},
            '2019-05-11:GBP' : {},

        }*/

        return exchangeRateMap;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([
          SELECT Id, Date__c, Currency__c
          FROM Expense_Item__c
          WHERE Exchange_Rate__c = 0
      ]);
   }

   global void execute(Database.BatchableContext BC, List<Expense_Item__c> scope){
       Map<String, Exchange_Rate__c> exchangeRateByDateAndCurrency = populateExchangeRates(scope);
       List<Expense_Item__c> expenseItemsToUpdate = new List<Expense_Item__c>();

       for (Expense_Item__c itemObj : scope) {
           String dateCurrencyKey = itemObj.Date__c + ':' + itemObj.Currency__c;
           Exchange_Rate__c exchangeRate = exchangeRateByDateAndCurrency.get(dateCurrencyKey);

           itemObj.Exchange_Rate__c = exchangeRate.Rate__c;
           expenseItemsToUpdate.add(itemObj);
       }

        update expenseItemsToUpdate;
   }

   global void finish(Database.BatchableContext BC) {

   }
}
