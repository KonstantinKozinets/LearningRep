@IsTest
private class AccountHierarchyTest {

    @testSetup
    static void TestSetup() {

        Integer branch;
        Integer account;
        List<Account> testAccounts = new List<Account>();
        Id accBranchOneId;

        for (account = 1; account < 11; account++) {
            testAccounts.add(new Account(Name = 'vTestLvl' + account));
        }

        insert testAccounts;

        for (Account abo: testAccounts){
            abo.ParentId = accBranchOneId;
            accBranchOneId = abo.id;
        }

        insert new List<Account>{
            new Account(Name ='v1 Second Child Acc', ParentId = testAccounts[2].Id),
            new Account(Name ='v2 Second Child Acc', ParentId = testAccounts[6].Id)
        };

        update testAccounts;
    }

    @isTest
    static void getParentsTest() {

        Account acc = [
            SELECT Id, Name, ParentId
            FROM Account
            WHERE Name = 'vTestLvl6'
            LIMIT 1
        ];

        Test.startTest();
        List<Account> parents = AccountHierarchy.getParents(acc.Id);
        Test.stopTest();

        System.assertEquals(5, parents.size());

    }

	@isTest
    static void getChildrenTest() {

        Account acc = [
            SELECT Id, Name, ParentId
            FROM Account
            WHERE Name = 'vTestLvl5'
            LIMIT 1
        ];

        Test.startTest();
        List<Account> children = AccountHierarchy.getChildren(acc.Id);
        Test.stopTest();

        System.assertEquals(6, children.size());
    }

	@isTest
    static void getParentsMapTest() {

        Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Name LIKE 'v%']);

        Test.startTest();
        Map<Id, List<Account>> parentsMap = AccountHierarchy.getParents(accountsMap.keySet());
        Test.stopTest();

        for (Account acc : accountsMap.values()) {
            if (acc.Name.equals('vTestLvl6')) {
                System.assertEquals(5, parentsMap.get(acc.Id).size());
            }
		}
    }

    @isTest
    static void getChildrenMapTest() {

        Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Name LIKE 'v%']);

        Test.startTest();
        Map<Id, List<Account>> childrenMap = AccountHierarchy.getChildren(accountsMap.keySet());
        Test.stopTest();

        for (Account acc : accountsMap.values()) {
            if (acc.Name.equals('vTestLvl5')) {
                System.assertEquals(6, childrenMap.get(acc.Id).size());
            }
		}
    }
}