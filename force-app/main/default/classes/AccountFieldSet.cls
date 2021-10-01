public with sharing class AccountFieldSet {

    @AuraEnabled
    public List<Account> accounts;

    @AuraEnabled
    public List<AccountWrapper> fieldSet;

    @AuraEnabled
    public List<AccountFieldsWrapper> accFields;

    public AccountFieldSet(List<Account> accounts, List<AccountWrapper> fieldSet, List<AccountFieldsWrapper> accFields) {
        this.accounts = accounts;
        this.fieldSet = fieldSet;
        this.accFields = accFields;
    }

    public static List<AccountWrapper> getFields() {
        List<AccountWrapper> fields = new List<AccountWrapper>();

        for (Schema.FieldSetMember g : SObjectType.Account.FieldSets.Account_Table.getFields()) {
            fields.add(new AccountWrapper(g.getFieldPath(), g.getLabel(), String.valueOf(g.getType())));
        }
        // fields.add(
        //     new AccountWrapper(
        //         'Details', 'details', 'action', new ActionWrapper('Show Details', 'show_details', 'left')
        //     )
        // );

        fields.add(new AccountWrapper('View', 'view', 'text'));

        return fields;
    }

    public static List<AccountFieldsWrapper> getAccFields() {
        List<AccountFieldsWrapper> fields = new List<AccountFieldsWrapper>();

        for (Schema.FieldSetMember g : SObjectType.Account.FieldSets.Account_Table.getFields()) {
            fields.add(new AccountFieldsWrapper(g.getFieldPath(), 'Account'));
        }

        return fields;
    }

    public static String getAccounts() {
        String query = 'SELECT ';

        for (AccountWrapper f : AccountFieldSet.getFields()) {
            if(f.fieldName != 'Name') {
                query += f.fieldName + ', ';
            }
        }

        query += 'Id, Name FROM Account LIMIT 50000';
        return query;
    }

    public class AccountWrapper {
        @AuraEnabled
        public String fieldName;

        @AuraEnabled
        public String label;

        @AuraEnabled
        public String type;

        @AuraEnabled
        public ActionWrapper typeAttributes;

        public AccountWrapper(String name, String label, String type) {
            this.fieldName = name;
            this.label = label;
            this.type = type.toLowerCase();
            this.typeAttributes = new ActionWrapper(null, null, null);
        }

        public AccountWrapper(String name, String label, String type, ActionWrapper typeAttributes) {
            this.fieldName = name;
            this.label = label;
            this.type = type.toLowerCase();
            this.typeAttributes = typeAttributes;
        }
    }

    public class ActionWrapper {
        @AuraEnabled
        public String label;

        @AuraEnabled
        public String name;

        @AuraEnabled
        public String menuAlignment;

        public ActionWrapper(String label, String name, String menuAlignment) {
            this.label = label;
            this.name = name;
            this.menuAlignment = menuAlignment;
        }
    }

    public class AccountFieldsWrapper {
        @AuraEnabled
        public String fieldApiName;

        @AuraEnabled
        public String objectApiName;

        public AccountFieldsWrapper(String fieldApiName, String objectApiName) {
            this.fieldApiName = fieldApiName;
            this.objectApiName = objectApiName;
        }
    }

    @AuraEnabled
    public static AccountFieldSet getAccountList(){
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(Database.getQueryLocator(getAccounts()));

        try {
            return new AccountFieldSet(setCon.getRecords(), getFields(), getAccFields());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}