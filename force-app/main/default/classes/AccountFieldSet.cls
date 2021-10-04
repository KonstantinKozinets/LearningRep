public with sharing class AccountFieldSet {

    @AuraEnabled
    public List<Account> accounts;

    @AuraEnabled
    public List<AccountWrapper> fieldSet;

    @AuraEnabled
    public List<AccountFieldsWrapper> accFields;

    @AuraEnabled
    public Integer pageNumber;

    @AuraEnabled
    public Integer pageCount;

    public AccountFieldSet(
        List<Account> accounts,
        List<AccountWrapper> fieldSet,
        List<AccountFieldsWrapper> accFields,
        Integer pageNumber,
        Integer pageCount
    ) {
        this.accounts = accounts;
        this.fieldSet = fieldSet;
        this.accFields = accFields;
        this.pageNumber = pageNumber;
        this.pageCount = pageCount;
    }

    public static List<AccountWrapper> getFields() {
        List<AccountWrapper> fields = new List<AccountWrapper>();

        for (Schema.FieldSetMember g : SObjectType.Account.FieldSets.Account_Table.getFields()) {
            fields.add(new AccountWrapper(g.getFieldPath(), g.getLabel(), String.valueOf(g.getType())));
        }

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

        public AccountWrapper(String fieldName, String label, String type) {
            this.fieldName = fieldName;
            this.label = label;
            this.type = type.toLowerCase();
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
    public static AccountFieldSet getAccountList(Integer pageNumber) {
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(Database.getQueryLocator(getAccounts()));
        setCon.setPageSize(12);
        Integer pageCount = setCon.getResultSize()/setCon.getPageSize();

        if (pageNumber == null) {
            setCon.first();
        } else {
            if (pageNumber <= pageCount && pageNumber >= 1) {
                setCon.setPageNumber(pageNumber);
            } else {
                setCon.first();
            }
        }

        try {
            return new AccountFieldSet(setCon.getRecords(), getFields(), getAccFields(), setCon.getPageNumber(), pageCount);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}