@isTest
public class ExpenseItemTriggerTest {
    @isTest
    public static void whenExpenseItemInsertedReimbursableAmountCorrect() {

        // select consultant into user 
        User user = [
            SELECT Id
            FROM User
            WHERE Profile.Name = 'Consultant'
            LIMIT 1
          ];
        System.assert(user != null, 'Consultant User Exists');

      System.runAs(user) {
        // save a new expense report

        // get category with reimbursable percent 1 and store in variable reimbursable100

        // get category with reimbursable percent .5 and store in variable reimbursable50

        // instantiate list of expense items to save later

        // instantiate a expense item itemJPY100 with currency JPY, category: reimbursable100, amount: 100, date: yesterday
        Expense_Item__c itemJPY100 = new Expense_Item__c(
          Expense_Report__c = expenseReport.Id,
          Expense_Category__c = reimbursable100.Id,
          Description__c = 'JPY 100',
          Date__c = System.today() - 1,
          Currency__c = 'JPY',
          Amount__c = 100
        );

        // add to list
        items.add(itemJPY100);

        // instantiate a expense item itemUSD100 with currency USD, category: reimbursable100, amount: 100, date: yesterday
        // add to list

        // instantiate a expense item itemJPY50 with currency JPY, category: reimbursable50, amount:100, date: day before yesterday
        // add to list

        // instantiate a expense item itemUSD50 with currency USD, category: reimbursable50, amount: 100, date: day before yesterday
        // add to list

        Test.startTest();
          // insert items
        Test.stopTest();

        // select saved items and data to assert into a map for easy fetching by id
        Map<Id, Expense_Item__c> savedItems = new Map<Id, Expense_Item__c>([
          SELECT Id, Exchange_Rate__c, Reimbursable_Amount__c
          FROM Expense_Item__c
        ]);

        // TODO update test when fx rates are captured
        // get itemJPY100 by Id from the map
        // assert exchange rate is 0
        // assert reimbursable amount is 0
 
        // get itemUSD100 by Id from the map
        // assert exchange rate is 1
        // assert reimbursable amount is 100

        // TODO update test when fx rates are captured
        // get itemJPY50 by Id from the map
        // assert exchange rate is 0
        // assert reimbursable amount is 0

        // get itemUSD50 by Id from the map
        // assert exchange rate is 1
        // assert reimbursable amount is 50

      }
    }

    @isTest
    public static void whenExpenseItemUpdatedReimbursableAmountCorrect() {

      // create test to verify when saved expense item is updated to USD from JPY, exchange rate changes from 0 to 1 
      // create test to verify when saved expense item is updated to JPY from USD, exchange rate changes from 1 to 0
      // run as Consultant
     
    }

    @testSetup
    static void makeData() {
      List<Expense_Category__c > categories = new List<Expense_Category__c >();

      categories.add(new Expense_Category__c(
          Name = 'Gas',
          Reimbursable_Percentage__c = 100
      ));

      categories.add(new Expense_Category__c(
          Name = 'Dining',
          Reimbursable_Percentage__c = 50
      ));
      insert categories;
      // setup test 2 categories for each test
      // 100% and 50% reimbursable
      // practice bulkification
      // add categories to list
      // save list

    }
}