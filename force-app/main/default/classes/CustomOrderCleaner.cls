public class CustomOrderCleaner implements Schedulable {

    public void execute(SchedulableContext ctx) {
        List<Custom_Order__c> ordersToDelete = [
            SELECT Id
            FROM Custom_Order__c
            WHERE Status__c = 'Draft'
        ];

        if (!ordersToDelete.isEmpty()) {
            delete ordersToDelete;
        }
    }
}