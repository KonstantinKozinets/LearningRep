@isTest
global class ZoomIntegrationMock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        List<PhoneNumber> numbers = new List<PhoneNumber>();
        Map<String, List<PhoneNumber>> mapNumbers = new Map<String, List<PhoneNumber>>();
        String t = ' ';

        res.setHeader('Content-Type', 'application/json');
        for (Integer i = 0; i <= 25; i++) {
            PhoneNumber tt = new PhoneNumber(t, t, t, t, true);
            tt.country = 'CNT'+i;
            tt.code = '+' + (i+10);
            tt.nNumber = '555'+i+'22';
            tt.label = 'Mobile';
            tt.verified = true;
            numbers.add(tt);
        }

        for (Integer i = 30; i <= 55; i++) {
            PhoneNumber tt = new PhoneNumber(t, t, t, t, true);
            tt.country = 'CNT'+i;
            tt.code = '+' + (i+10);
            tt.nNumber = '555'+i+'22';
            tt.label = 'Home';
            tt.verified = true;
            numbers.add(tt);
        }

        mapNumbers.put('phone_numbers', numbers);
        String respondString = JSON.serialize(mapNumbers);
        res.setBody(respondString);
        res.setStatusCode(200);
        return res;
    }
}