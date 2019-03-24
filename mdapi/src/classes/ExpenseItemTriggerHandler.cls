public class ExpenseItemTriggerHandler extends TriggerHandler {
    public static void AssignExchangeRate(List<Expense_Item__c> itemList) {
        List<Expense_Item__c> listToUpdate = new List<Expense_Item__c>();

        for (Expense_Item__c itemObj : itemList){
            if (itemObj.Currency__c == 'USD') {
                itemObj.Exchange_Rate__c = 1;
            } else {
                itemObj.Exchange_Rate__c = 0;
            }
            listToUpdate.add(itemObj);
        }
    }

    private void beforeInsert(List<Expense_Item__c> itemList) {
        AssignExchangeRate(itemList);
    }
    
    private void beforeUpdate(List<Expense_Item__c> itemList) {
        AssignExchangeRate(itemList);
    }

    private void beforeDelete(List<Expense_Item__c> itemList) { 
        //Not much going on here... 
    }

    private void afterInsert(List<Expense_Item__c> itemList) {
        //Not much going on here...
    }

    private void afterUpdate(List<Expense_Item__c> itemList) {
        //Not much going on here...
    }

    private void afterDelete(List<Expense_Item__c> itemList) {
        //Not much going on here...
    }
}