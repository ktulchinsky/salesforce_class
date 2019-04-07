trigger ExpenseCategoryTrigger on Expense_Category__c (after update) {
    Set<Id> expenseCategoryIds = new Set<Id>();

    for (Expense_Category__c newCat : Trigger.new) {
        Expense_Category__c oldCat = Trigger.oldMap.get(newCat.Id);
        
        if (oldCat.Reimbursable_Percentage__c != newCat.Reimbursable_Percentage__c) {
           expenseCategoryIds.add(newCat.Id);
        }
    }

    // Handy list
    List<Expense_Item__c> expenseItems = new List<Expense_Item__c>([
        SELECT Id, Reimbursable_amount__c,
        Amount__c,
        Expense_Category__c,
        Exchange_Rate__c
        FROM Expense_Item__c
        WHERE Expense_Category__c in :expenseCategoryIds
    ]);

    List<Expense_Item__c> expenseItemsToUpdate = new List<Expense_Item__c>();

    for (Expense_Item__c item: expenseItems) {
        item.Reimbursable_amount__c = item.Exchange_Rate__c * item.Amount__c * (Trigger.newMap.get(item.Expense_Category__c).Reimbursable_Percentage__c/100);
        expenseItemsToUpdate.add(item);
    }

    if(expenseItemsToUpdate.size() > 0){
        update expenseItemsToUpdate;
    }
}