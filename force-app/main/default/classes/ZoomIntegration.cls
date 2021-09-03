public class ZoomIntegration {

    @InvocableMethod
    public static void Integrate(List<String> campaignId) {
        if(!campaignId.isEmpty()) {
            List<CampaignMember> campaignMembers = new List<CampaignMember>();
            List<Contact> contactsMerge = new List<Contact>();
            List<Contact> existingContactsList = [
                SELECT LastName, FirstName, Email
                FROM Contact
                WHERE Email != NULL
                LIMIT 50000
            ];
            Map<String, Contact> existingContactsMap = new Map<String, Contact>();

            for (Contact contact : existingContactsList) {
                existingContactsMap.put(contact.Email, contact);
            }

            List<Contact> zoomContacts = getContactNumbers();
            for (Contact zoomContact : zoomContacts) {
                if(existingContactsMap.containsKey(zoomContact.Email)) {
                    existingContactsMap.get(zoomContact.Email).Phone = zoomContact.Phone;
                    existingContactsMap.get(zoomContact.Email).MobilePhone = zoomContact.MobilePhone;
                    contactsMerge.add(existingContactsMap.get(zoomContact.Email));
                } else {
                    contactsMerge.add(zoomContact);
                }
            }

            try {
                upsert contactsMerge;
                for (Contact cont : contactsMerge) {
                    campaignMembers.add(
                        new CampaignMember(CampaignId = campaignId[0], ContactId = cont.Id)
                    );
                }
                upsert campaignMembers;
            } catch(DmlException e) {

            }
        }
    }

    private static List<Contact> getContactNumbers() {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Zoom_Master_Connect/users/me');
        request.setMethod('GET');
        List<Contact> contactNumbers = new List<Contact>();

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<PhoneNumber> pNumbers = (List<PhoneNumber>) results.get('phone_numbers');
            String jNumbers = JSON.serialize(pNumbers).replaceAll('number', 'nNumber');
            List<PhoneNumber> numbers = (List<PhoneNumber>) JSON.deserialize(jNumbers, List<PhoneNumber>.class);

            for (PhoneNumber phone : numbers) {
                contactNumbers.add(
                    new Contact(
                        FirstName = phone.country,
                        LastName = phone.nNumber,
                        Email = phone.nNumber + '@gmail.com',
                        Phone = phone.code + phone.nNumber
                    )
                );
            }
        }

        return contactNumbers;
    }
}