public  class ContactTitleBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, FirstName, LastName, Title ' +
            'FROM Contact ' +
            'WHERE FirstName = \'FirstJob\' AND LastName = \'SecondJob\''
        );
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        for(Contact contact : scope) {
            contact.Title = 'Async Apex';
        }

        update scope;
    }

    public void finish(Database.BatchableContext bc) {

        Id jobId = [
            SELECT Id
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()
            LIMIT 1
        ].Id;

        System.abortJob(jobId);
    }
}