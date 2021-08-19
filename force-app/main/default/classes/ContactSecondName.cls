public class ContactSecondName implements Queueable {

    private List<Contact> contacts;

    public ContactSecondName(List<Contact> contactsToUpdate) {
        contacts = contactsToUpdate == null ? new List<Contact>() : contactsToUpdate;
    }

    public void execute(QueueableContext qc) {
        for (Contact contact : contacts) {
            contact.LastName = 'SecondJob';
        }

        if (!contacts.isEmpty()) {
            insert contacts;
        }

        if (!Test.isRunningTest()) {
            CallBatch.call();
        }
    }
}