public class ContactController {

    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts() {
        List<Contact> contacts = [
            SELECT LastName, FirstName, Email
            FROM Contact
            WITH SECURITY_ENFORCED
            ORDER BY FirstName
            LIMIT 100
        ];

        return contacts;
    }
}