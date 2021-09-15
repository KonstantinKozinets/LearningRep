public class PhoneNumber {
    public String code;
	public String country;
    public String label;
    public String nNumber;
    public Boolean verified;

    public PhoneNumber(
        String zCode,
        String zCountry,
        String zLabel,
        String zNumber,
        Boolean zVerified
    ) {
        country = zCountry;
        code = zCode;
        nNumber = zNumber;
        label = zLabel;
		verified = zVerified;
    }
}




/* List<PhoneNumber> numbers = new List<PhoneNumber>();
for (Integer i = 0; i <= 25; i++) {
    numbers.add(new PhoneNumber(
    	country = 'CNT'+i,
        code = '+' + (i+10),
        nNumber = '555'+i+'22',
        label = 'Mobile',
		verified = true
    ));
}

for (Integer i = 30; i <= 55; i++) {
    numbers.add(new PhoneNumber(
    	country = 'CNT'+i,
        code = '+' + (i+10),
        nNumber = '555'+i+'22',
        label = 'Home',
		verified = true
    ));
}

System.debug(numbers);

*/