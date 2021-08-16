global class ScheduledJob implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Contact> contacts = [
            SELECT Id, Name
            FROM Contact
        ];
        createOrders(contacts);
    }

    public void createOrders(List<Contact> contacts) {
        List<Custom_Order__c> orders = new List<Custom_Order__c>();

        for (Contact contact : contacts) {
            orders.addAll(new List<Custom_Order__C> {
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id),
                new Custom_Order__c(Status__c = 'Draft', Contact__c = contact.Id)
            });
        }

        insert orders;
    }
}