public  class ContactTitleBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT FirstName, LastName, Title ' +
            'FROM Contact ' +
            'WHERE FirstName = \'FirstJob\' AND LastName = \'SecondJob\''
        );
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        for (Contact contact : scope) {
            contact.Title = 'Async Apex';
        }

        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.abortJob(bc.getJobId());
    }
}