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