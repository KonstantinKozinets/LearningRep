public class ZoomIntegration {

    @InvocableMethod
    public static void Integrate(List<String> meetingId) {
        if (!meetingId.isEmpty()) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String author = 'AZeGzmMwnCBN8UCqZdeTegxb0xZZ6jmB';
            request.setHeader('Authorization', author);
            request.setEndpoint('callout:Zoom_Master_Connect/v2/meetings/' + meetingId[0] + '/registrants/');
            request.setMethod('GET');
            List<CampaignMember> campaignMembers = new List<CampaignMember>();
            List<Contact> existingContactsList = [
                SELECT LastName, FirstName, Email
                FROM Contact
                WHERE Email != NULL
                LIMIT 50000
            ];
            Map<String, Contact> existingContactsMap = new Map<String, Contact>();
            Id campaign = '7015g000000557HAAQ';

            for (Contact contact : existingContactsList) {
                existingContactsMap.put(contact.Email, contact);
            }

            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                //Map<String, Object> participants = (Map<String, Object>) results.get('participants');
                Map<String, Object> registrants = (Map<String, Object>) results.get('registrants');
                List<Contact> newContacts = new List<Contact>();

                /*for (String participant : participants.keySet()) {
                    Map<String, Object> options = (Map<String, Object>) participants.get(participant);

                    Contact contact = new Contact(
                        LastName = (String) options.get('Name'),
                        Email = (String) options.get('User_Email')
                    );

                    try {
                        Contact ex = existingContactsMap.get(contact.Email);
                        campaignMembers.add(
                            new CampaignMember( ContactId = ex.Id, CampaignId = campaign)
                        );
                    } catch (System.NullPointerException e) {
                        newContacts.add(contact);
                    }

                }*/

                for (String registrant : registrants.keySet()) {
                    Map<String, Object> options = (Map<String, Object>) registrants.get(registrant);

                    Contact contact = new Contact(
                        LastName = (String) options.get('LastName'),
                        Email = (String) options.get('Email'),
                        FirstName = (String) options.get('FirstName')
                    );

                    try {
                        Contact ex = existingContactsMap.get(contact.Email);
                        campaignMembers.add(
                            new CampaignMember( ContactId = ex.Id, CampaignId = campaign)
                        );
                    } catch (System.NullPointerException e) {
                        newContacts.add(contact);
                    }
                }

                try {
                    insert newContacts;

                    for (Contact c : newContacts) {
                        campaignMembers.add(
                            new CampaignMember( CampaignId = campaign, ContactId = c.Id)
                        );
                    }

                    insert campaignMembers;

                } catch (DmlException e) {
                    System.debug(e.getMessage());
                }

            } else {
                System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
            }
        }
    }

}