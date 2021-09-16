@isTest
public class ZoomIntegrationTest {

    @TestSetup
    private static void testSetup() {
        List<Campaign> nullCampaigns = new List<Campaign>{
            new Campaign(Name = 'TestCampaign')
        };

        insert nullCampaigns;

        List<Contact> nullContacts = new List<Contact>();
        List<CampaignMember> nullCampaignMembers = new List<CampaignMember>();

        for (Integer i = 0; i < 5; i++) {
            nullContacts.add(new Contact(FirstName = 'CNT'+i+'_Mobile', LastName = '555'+i+'22', email = '555'+i+'22@gmail.com'));
        }

        insert nullContacts;

        for (Contact c : nullContacts) {
            nullCampaignMembers.add(
                new CampaignMember(campaignId = nullCampaigns[0].id, contactId = c.Id)
            );
        }
    }

    @isTest
    private static void testIntegrateGoodResult() {
        Test.setMock(HttpCalloutMock.class, new ZoomIntegrationMock());
        String phoneType = 'Home';
        String sdPhoneType = 'Mobile';
        String nullPT;

        String campaignId = [
            SELECT Id
            FROM Campaign
            LIMIT 1
        ][0].Id;

        test.startTest();
        String result = ZoomIntegration.integrate(phoneType, campaignId);
        test.stopTest();

        System.assertEquals(26, [SELECT COUNT() FROM CampaignMember]);
        System.assertEquals('Success.', result);

    }

    private static void testIntegrateNullResult() {
        Test.setMock(HttpCalloutMock.class, new ZoomIntegrationMock());

        String campaignId = [
            SELECT Id
            FROM Campaign
            LIMIT 1
        ][0].Id;

        test.startTest();
        String result = ZoomIntegration.integrate('Fax', campaignId);
        test.stopTest();

        System.assertEquals('No such phone defined at Zoom database.', result);
    }

    private static void testIntegrateBadResult() {
        Test.setMock(HttpCalloutMock.class, new ZoomIntegrationMock());
        String nullPT;

        String campaignId = [
            SELECT Id
            FROM Campaign
            LIMIT 1
        ][0].Id;

        test.startTest();
        String result = ZoomIntegration.integrate(nullPT, campaignId);
        test.stopTest();

        System.assertEquals('Fail pType.', result);
    }
}