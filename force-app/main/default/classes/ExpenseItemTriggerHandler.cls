public class ExpenseItemTriggerHandler extends TriggerHandler {
    public static void AssignExchangeRate(List<Expense_Item__c> itemList) {
        List<Expense_Item__c> listToUpdate = new List<Expense_Item__c>();

        for (Expense_Item__c itemObj : itemList){
            if (itemObj.Currency__c == 'USD') {
                itemObj.Exchange_Rate__c = 1;
            } else {
                itemObj.Exchange_Rate__c = itemObj.Exchange_Rate__c;
            }
            listToUpdate.add(itemObj);
        }
    }

    public static void CalculateReimbursableAmount(List<Expense_Item__c> itemList){
        List<Expense_Item__c> listToUpdate = new List<Expense_Item__c>();

        Map<Id, Expense_Category__c> categories = new Map<Id, Expense_Category__c>([
          SELECT Id, Reimbursable_Percentage__c
          FROM Expense_Category__c
        ]);

        //    Expense_Category__c thisExpenseCategory = [ 
        //        SELECT 
        //        Id, 
        //        Reimbursable_Percentage__c 
        //        FROM Expense_Category__c 
        //        WHERE Id = :itemObj.Expense_Category__c  //WHERE Expense_Category__c in :expenseCategoryIds
        //     ];

        for (Expense_Item__c itemObj : itemList){
           itemObj.Reimbursable_amount__c = itemObj.Exchange_Rate__c * itemObj.Amount__c * (categories.get(itemObj.Expense_Category__c).Reimbursable_Percentage__c/100);
           listToUpdate.add(itemObj); 
        }
    }

    private void beforeInsert(List<Expense_Item__c> itemList) {
        AssignExchangeRate(itemList);
        CalculateReimbursableAmount(itemList);
    }
    
    private void beforeUpdate(List<Expense_Item__c> itemList) {
        AssignExchangeRate(itemList);
        CalculateReimbursableAmount(itemList);
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