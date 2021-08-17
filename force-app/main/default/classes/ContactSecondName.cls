public class ContactSecondName implements Queueable {

    private List<Contact> contacts;

    public ContactSecondName (List<Contact> contactsToUpdate) {
        contacts = contactsToUpdate;
    }

    public void execute (QueueableContext qc) {
        for (Contact contact : contacts) {
            contact.LastName = 'SecondJob';
        }

        if (contacts.size() > 0) {
            insert contacts;
        }

        if (!Test.isRunningTest()) { CallBatch.call(); }
    }

}