public class PhoneNumberIterable implements System.Iterable<PhoneNumber> {

    public Iterator<PhoneNumber> iterator() {
        List<PhoneNumber> numbers = new List<PhoneNumber>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Zoom_Master_Connect/users/me');
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> pNumbers = (List<Object>) results.get('phone_numbers');
            String jNumbers = JSON.serialize(pNumbers).replaceAll('number', 'nNumber');
            numbers = (List<PhoneNumber>) JSON.deserialize(jNumbers, List<PhoneNumber>.class);
        }

        return new PhoneNumberIterator(numbers);
    }

}