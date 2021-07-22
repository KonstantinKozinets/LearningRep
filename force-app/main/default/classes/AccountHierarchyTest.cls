@IsTest
public class AccountHierarchyTest {

    @testSetup
    static void TestSetup(){

        Integer branch;
        Integer account;
        List<Account> testAccs = new List<Account>();
        for(branch = 1; branch < 3; branch++){
            for(account = 1; account < 6; account++){
                String accName = 'v'+branch+'TestLvl'+account;
                Account acc = new Account(Name = accName);
                testAccs.add(acc);
            }
        }
        insert testAccs;

        List<Account> accsBranchOne = [SELECT Id, Name, ParentId
                                       FROM Account
                                       WHERE Name LIKE 'v1%'];
        Id accBranchOneId = null;
        System.debug('------------------------------ Branch one -----------------------------------');
        for(Account abo: accsBranchOne){
            abo.ParentId = accBranchOneId;
            accBranchOneId = abo.id;
            System.Debug('Account ' + abo.Name + '. Id: ' + abo.Id + ' inserted with Parent Id: ' + abo.ParentId);
        }

        update accsBranchOne;

        List<Account> accsBranchTwo = [SELECT Id, Name, ParentId
                                       FROM Account
                                       WHERE Name LIKE 'v2%'];
        Id accBranchTwoId = null;
        System.debug('------------------------------ Branch two -----------------------------------');
        for(Account abt: accsBranchTwo){
            abt.ParentId = accBranchTwoId;
            accBranchTwoId = abt.id;
            System.Debug('Account ' + abt.Name + '. Id: ' + abt.Id + ' inserted with Parent Id: ' + abt.ParentId);
        }

        update accsBranchTwo;
        System.debug('---------------------------------- Updated ----------------------------------');

    }

    @isTest
    static void AccountParentsTest() {

        Account acc = [SELECT Id, Name, ParentId
                       FROM Account
                       WHERE Name = 'v1TestLvl3'
                       LIMIT 1];

        System.debug('------------------------ Checking Parents for Acc ---------------------------');
        System.debug('Account picked: Name = '+acc.Name+'. Id = '+acc.Id);

        Test.startTest();
        List<Account> parents = AccountHierarchy.AccountParents(acc);
        Test.stopTest();

        integer i = 1;
        for(Account par: parents){
            System.debug('Parent ' + i + ' for this acc: ' + par.Name + '. Id: ' + par.Id);
            i++;
        }

        System.assertEquals(2,parents.size());
        System.debug('-----------------------------------------------------------------------------');

    }

	@isTest
    static void AccountSubsTest() {

        Account acc = [SELECT Id, Name, ParentId
                       FROM Account
                       WHERE Name = 'v1TestLvl3'
                       LIMIT 1];

        System.debug('---------------------- Checking SubAccounts for Acc -------------------------');
        System.debug('Account picked: Name = '+acc.Name+'. Id = '+acc.Id);

        Test.startTest();
        List<Account> subs = AccountHierarchy.AccountSubs(acc);
        Test.stopTest();

        integer i = 1;
        for(Account sub: subs){
            System.debug('Sub ' + i + ' for this acc: ' + sub.Name + '. Id: ' + sub.Id);
            i++;
        }

        System.assertEquals(2,subs.size());
        System.debug('-----------------------------------------------------------------------------');

    }

	@isTest
    static void ParentsMapTest() {

        List<Account> accs = [SELECT Id, ParentId, Name
                              FROM Account
                              WHERE Name LIKE 'v%'];
        System.debug('----------------------- Testing ParentsMap for Acc ------------------------');
        System.debug('Accounts for test list: ');
        for (Account acc: accs){
            System.debug('Name = ' + acc.Name+'. Id = ' + acc.Id + '. ParentId: ' + acc.ParentId);
        }

        Test.startTest();
         Map<String,List<Account>> parentMap = AccountHierarchy.ParentsMap(accs);
        Test.stopTest();

        for (String key : parentMap.keySet()) {
            System.debug('--------------------- Parents of Acc ' + key);
            for (Account acct : parentMap.get(key)) {
                System.debug('*** Parent Name: ' + acct.Name + '. Id: '+acct.Id);
            }
		}
        System.debug('-----------------------------------------------------------------------------');
    }

    @isTest
    static void SubsMapTest() {

        List<Account> accs = [SELECT Id, ParentId, Name
                              FROM Account
                              WHERE Name LIKE 'v%'];
        System.debug('----------------------- Testing SubAccountsMap for Acc ------------------------');
        System.debug('Accounts for test list: ');
        for (Account acc: accs){
            System.debug('Name = ' + acc.Name+'. Id = ' + acc.Id + '. ParentId: ' + acc.ParentId);
        }

        Test.startTest();
         Map<String,List<Account>> subMap = AccountHierarchy.SubsMap(accs);
        Test.stopTest();

        for (String key : subMap.keySet()) {
            System.debug('---------------- Subs of Acc --------------' + key);
            for (Account acct : subMap.get(key)) {
                System.debug('*** Sub Name: ' + acct.Name + '. Id: '+acct.Id);
            }
		}
    }
}