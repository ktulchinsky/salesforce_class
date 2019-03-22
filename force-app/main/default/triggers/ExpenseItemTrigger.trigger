trigger ExpenseItemTrigger on Expense_Item__c (before update) {
    List<Expense_Item__c> listToUpdate = new List<Expense_Item__c>();

    for (Expense_Item__c item: Trigger.new){
        if (item.Currency__c == 'USD') {
            item.Exchange_Rate__c = 1;
            listToUpdate.add(item);
        } else {
            item.Exchange_Rate__c = 0;
            listToUpdate.add(item);
        }
    }
    update listToUpdate;
}