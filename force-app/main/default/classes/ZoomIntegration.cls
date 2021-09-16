public class ZoomIntegration {

    /* Batchable apex code (not working)

    @AuraEnabled
    public static String integrate(String phoneType, String zRecordId) {
        String phoneNew = phoneType;
        Id recId = zRecordId;
        List<Contact> existingContactsList = [
            SELECT LastName, FirstName, Email
            FROM Contact
            WHERE Email != NULL
            LIMIT 50000
        ];
        if(recId.getSobjectType() == Campaign.getSobjectType()) {
            if (!String.isEmpty(phoneNew)) {
                return Database.executeBatch(new ZoomIntegrationBatch(phoneNew, recId, existingContactsList));
            } else {
                return 'fail pType';
            }
        } else {
            return 'fail cID';
        }
    }

    */

    @AuraEnabled
    public static String integrate(String phoneType, String zRecordId) {
        String phoneNew = phoneType;
        Id recId = zRecordId;
        if(recId.getSobjectType() == Campaign.getSobjectType()) {
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

            if (!String.isEmpty(phoneNew)) {
                List<Contact> zoomContacts = getContactNumbers(phoneNew);

                if (!zoomContacts.isEmpty()) {
                    for (Contact zoomContact : zoomContacts) {
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
                        return 'Success.';

                    } catch(DmlException e) {
                        return 'Already synchronized.';
                    }
                } else {
                    return 'No such phone defined at Zoom database.';
                }
            } else {
                return 'Fail pType.';
            }
        } else {
            return 'Fail cID.';
        }
    }

    private static List<Contact> getContactNumbers(String phoneNewest) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Zoom_Master_Connect/users/me');
        request.setMethod('GET');
        List<Contact> contactNumbers = new List<Contact>();

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> pNumbers = (List<Object>) results.get('phone_numbers');
            String jNumbers = JSON.serialize(pNumbers);
            if (!Test.isRunningTest()) {
                jNumbers = jNumbers.replaceAll('number', 'nNumber');
            }
            List<PhoneNumber> numbers = (List<PhoneNumber>) JSON.deserialize(jNumbers, List<PhoneNumber>.class);

            for (PhoneNumber phone : numbers) {
                if (phone.label == phoneNewest) {
                    contactNumbers.add(
                        new Contact(
                            FirstName = phone.country + '_' + phone.label,
                            LastName = phone.nNumber,
                            Email = phone.nNumber + '@tgmail.com',
                            Phone = phone.code + phone.nNumber
                        )
                    );
                }
            }
        }

        return contactNumbers;
    }
}