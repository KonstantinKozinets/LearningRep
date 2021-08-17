public class ContactFirstName implements Queueable {
    public List<Contact> contacts = new List<Contact>();

    public void execute(QueueableContext qc) {
        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(FirstName = 'FirstJob', LastName = 'Test' + i));
        }

        Id testId = !Test.isRunningTest() ? System.enqueueJob(new ContactSecondName(contacts)) : null;
    }
}