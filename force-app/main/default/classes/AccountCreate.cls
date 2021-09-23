public with sharing class AccountCreate {

    @AuraEnabled
    public static Account insertAccount(Account toInsert) {
        insert toInsert;
        return toInsert;
    }
}
