public with sharing class AccountFieldSet {

    List<Account> accounts;
    List<String> fieldSet;

    public AccountFieldSet(List<Account> accounts, List<String> fieldSet) {
        this.accounts = accounts;
        this.fieldSet = fieldSet;
    }

    public static List<String> getFields() {
        List<String> fields = new List<String>();

        for (Schema.FieldSetMember g : SObjectType.Account.FieldSets.Account_Table.getFields()) {
            fields.add(g.getFieldPath());
        }
        return fields;
    }

    public static List<Account> getAccounts() {
        String query = 'SELECT ';

        for (String f : AccountFieldSet.getFields()) {
            if(f != 'Name') {
                query += f + ', ';
            }
        }

        query += 'Id, Name FROM Account LIMIT 50000';
        return Database.query(query);
    }

    @AuraEnabled
    public static List<AccountFieldSet> getAccountList(String fakeSt){
        String kk = fakeSt;
        try {
            return new List<AccountFieldSet> { new AccountFieldSet(getAccounts(), getFields()) };
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}