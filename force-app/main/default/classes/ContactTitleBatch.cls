public  class ContactTitleBatch implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(
            'SELECT ID, FirstName, LastName, Title ' +
            'FROM Contact ' +
            'WHERE FirstName = \'FirstJob\' AND LastName = \'SecondJob\''
        );
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope){
        for(Contact contact : scope){
            contact.Title = 'Async Apex';
        }

        update scope;
    }

    public void finish(Database.BatchableContext BC){


        Id jobId = [
            SELECT Id
            FROM CronTrigger
            LIMIT 1
        ].Id;

        System.abortJob(jobId);
    }
}