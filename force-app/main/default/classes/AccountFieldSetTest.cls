@isTest
public class AccountFieldSetTest {

    @TestSetup
    private static void testSetup() {
        insert (new List<Account>{
            new Account(Name = 'TestName1', BillingCity = 'TestCity1', Phone = '+999999999'),
            new Account(Name = 'TestName2', BillingCity = 'TestCity2', Phone = '+888888888'),
            new Account(Name = 'TestName3', BillingCity = 'TestCity3', Phone = '+777777777')
        });
    }

    @isTest
    private static void testGetPageOne() {
        AccountFieldSet testWr = new AccountFieldSet(
            new List<Account>{
                new Account(Name = 'TestName1', BillingCity = 'TestCity1', Phone = '+999999999'),
                new Account(Name = 'TestName2', BillingCity = 'TestCity2', Phone = '+888888888')
            },
            new List<AccountFieldSet.AccountWrapper>{
                new AccountFieldSet.AccountWrapper('Name', 'Account Name', 'string'),
                new AccountFieldSet.AccountWrapper('BillingCity', 'Billing City', 'string'),
                new AccountFieldSet.AccountWrapper('Phone', 'Account Phone', 'phone')
            },
            new List<AccountFieldSet.AccountFieldsWrapper>{
                new AccountFieldSet.AccountFieldsWrapper('Name', 'Account'),
                new AccountFieldSet.AccountFieldsWrapper('BillingCity', 'Account'),
                new AccountFieldSet.AccountFieldsWrapper('Phone', 'Account')
            },
            1, 2
        );

        Test.startTest();
        AccountFieldSet result = AccountFieldSet.getAccountList(1, 2);
        Test.stopTest();

        System.assertEquals(testWr.accounts.size(), result.accounts.size());
        System.assertEquals(testWr.accFields.size(), result.accFields.size());
        System.assertEquals(testWr.fieldSet.size(), result.fieldSet.size());
        System.assertEquals(testWr.pageNumber, result.pageNumber);
        System.assertEquals(testWr.pageCount, result.pageCount);
    }

    @isTest
    private static void testGetPageTwo() {
        AccountFieldSet testWr = new AccountFieldSet(
            new List<Account>{
                new Account(Name = 'TestName3', BillingCity = 'TestCity3', Phone = '+777777777')
            },
            new List<AccountFieldSet.AccountWrapper>{
                new AccountFieldSet.AccountWrapper('Name', 'Account Name', 'string'),
                new AccountFieldSet.AccountWrapper('BillingCity', 'Billing City', 'string'),
                new AccountFieldSet.AccountWrapper('Phone', 'Account Phone', 'phone')
            },
            new List<AccountFieldSet.AccountFieldsWrapper>{
                new AccountFieldSet.AccountFieldsWrapper('Name', 'Account'),
                new AccountFieldSet.AccountFieldsWrapper('BillingCity', 'Account'),
                new AccountFieldSet.AccountFieldsWrapper('Phone', 'Account')
            },
            2, 2
        );

        Test.startTest();
        AccountFieldSet result = AccountFieldSet.getAccountList(2, 2);
        Test.stopTest();

        System.assertEquals(testWr.accounts.size(), result.accounts.size());
        System.assertEquals(testWr.accFields.size(), result.accFields.size());
        System.assertEquals(testWr.fieldSet.size(), result.fieldSet.size());
        System.assertEquals(testWr.pageNumber, result.pageNumber);
        System.assertEquals(testWr.pageCount, result.pageCount);
    }

    @isTest
    static void testNullPN() {

        Test.startTest();
        AccountFieldSet result = AccountFieldSet.getAccountList(null, 2);
        Test.stopTest();

        System.assertEquals(1, result.pageNumber);
    }

    @isTest
    static void testIncorrectPageNumber() {

        Test.startTest();
        AccountFieldSet result = AccountFieldSet.getAccountList(100, 2);
        Test.stopTest();

        System.assertEquals(1, result.pageNumber);
    }

    @isTest
    static void testAuraHandledException() {

        Test.startTest();
        try{
            AccountFieldSet result = AccountFieldSet.getAccountList(null, null);
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('ApexError'));
        }
        Test.stopTest();

    }
}
