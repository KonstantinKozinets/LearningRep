public class PhoneNumberIterator implements Iterator<PhoneNumber> {
    private List<PhoneNumber> numbers;
    private Integer currentIndex;

    public PhoneNumberIterator(List<PhoneNumber> numbers){
        this.numbers = numbers;
        this.currentIndex = 0;
    }

    public boolean hasNext(){
        return currentIndex < numbers.size() - 1;
    }

    public PhoneNumber next(){
        if(hasNext()) {
            currentIndex++;
            return numbers[currentIndex];
        } else {
            throw new NoSuchElementException();
        }
    }

}