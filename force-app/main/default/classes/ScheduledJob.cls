public class ScheduledJob implements Schedulable {

    public void execute(SchedulableContext ctx) {
        createOrders([SELECT Name FROM Contact LIMIT 50000]);
    }

    private void createOrders(List<Contact> contacts) {
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

        if (!orders.isEmpty()) {
            insert orders;
        }
    }
}