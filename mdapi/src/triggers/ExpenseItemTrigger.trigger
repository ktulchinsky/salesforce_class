trigger ExpenseItemTrigger on Expense_Item__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ExpenseItemTriggerHandler handler = new ExpenseItemTriggerHandler();
    handler.execute();
}