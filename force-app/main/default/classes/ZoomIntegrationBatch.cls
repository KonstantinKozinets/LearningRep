public class ZoomIntegrationBatch implements Database.Batchable<PhoneNumber>, Database.Stateful{

    private List<Contact> existingContactsList;
    private String phoneNew;
    private Id recId;

    public ZoomIntegrationBatch(String phoneType, Id campaignId, List<Contact> ContactsList) {
        existingContactsList = ContactsList;
        phoneNew = phoneType;
        recId = campaignId;
    }

    List<CampaignMember> campaignMembers = new List<CampaignMember>();
    List<Contact> contactsMerge = new List<Contact>();
    Map<String, Contact> existingContactsMap = new Map<String, Contact>();

    public System.Iterable<PhoneNumber> start(Database.BatchableContext BC){
        return new PhoneNumberIterable();
    }

    public void execute(Database.BatchableContext BC, List<PhoneNumber> scope){
        List<Contact> contactNumbers = new List<Contact>();
        if (!scope.isEmpty()) {
            for (PhoneNumber phone : scope) {
                if (phone.label == phoneNew) {
                    contactNumbers.add(
                        new Contact(
                            FirstName = phone.country + ' ' + phone.label,
                            LastName = phone.nNumber,
                            Email = phone.nNumber + '@tgmail.com',
                            Phone = phone.code + phone.nNumber
                        )
                    );
                }
            }

            for (Contact zoomContact : contactNumbers) {
                if(existingContactsMap.containsKey(zoomContact.Email)) {
                    existingContactsMap.get(zoomContact.Email).Phone = zoomContact.Phone;
                    contactsMerge.add(existingContactsMap.get(zoomContact.Email));
                } else {
                    contactsMerge.add(zoomContact);
                }
            }

            try {
                upsert contactsMerge;
                for (Contact cont : contactsMerge) {
                    campaignMembers.add(
                        new CampaignMember(CampaignId = recId, ContactId = cont.Id)
                    );
                }
                upsert campaignMembers;
            } catch(DmlException e) {

            }
        }
    }

    public void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setToAddresses(new List<String> { 'kozinec.kostya@mail.ru' });
        mail.setReplyTo('kozinec.kostyaa@gmail.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}