@IsTest
public class AccountHierarchyTest {

    @testSetup
    static void TestSetup(){

        Integer branch;
        Integer account;
        List<Account> testAccounts = new List<Account>();
        Id accBranchOneId = null;

        for(account = 1; account < 11; account++){
            testAccounts.add(new Account( Name = 'vTestLvl' + account ));
        }

        insert testAccounts;

        for(Account abo: testAccounts){
            abo.ParentId = accBranchOneId;
            accBranchOneId = abo.id;
        }

        Account secondChildOne = new Account( Name ='v1 Second Child Acc', ParentId = testAccounts[2].id );
        insert secondChildOne;

        Account secondChildTwo = new Account( Name ='v2 Second Child Acc', ParentId = testAccounts[6].id );
        insert secondChildTwo;

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

        System.assertEquals(5,parents.size());

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

        System.assertEquals(6,children.size());

    }

	@isTest
    static void getParentsMapTest() {

        Set<Id> accounts = new Set<Id>(new Map<Id, Account>([SELECT Id FROM Account WHERE Name LIKE 'v%']).keySet());

        Test.startTest();
         Map<Id,List<Account>> parentsMap = AccountHierarchy.getParents(accounts);
        Test.stopTest();

        for (String key : parentsMap.keySet()) {
            System.assertEquals(parentsMap.get(key), AccountHierarchy.getParents(key));
		}
    }

    @isTest
    static void getChildrenMapTest() {

        Set<Id> accounts = new Set<Id>(new Map<Id, Account>([SELECT Id FROM Account WHERE Name LIKE 'v%']).keySet());

        Test.startTest();
         Map<Id,List<Account>> childrenMap = AccountHierarchy.getChildren(accounts);
        Test.stopTest();

        for (String key : childrenMap.keySet()) {
            System.assertEquals(childrenMap.get(key), AccountHierarchy.getChildren(key));
		}
    }
}