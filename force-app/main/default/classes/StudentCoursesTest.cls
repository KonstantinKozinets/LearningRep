@isTest
public class StudentCoursesTest {

    @TestSetup
    static void testSetup() {

        List<Student__c> students = new List<Student__c> { new Student__c(Name = 'TestStudent') };
        insert students;

        List<Course__c> courses = new List<Course__c> {
            new Course__c(Name = 'Everything'),
            new Course__c(Name = 'Test')
        };
        insert courses;

        List<Skill2__c> skills = new List<Skill2__c> {
            new Skill2__c(Name = 'English'),
            new Skill2__c(Name = 'Testing'),
            new Skill2__c(Name = 'Russian')
        };
        insert skills;

        List<Preference__c> preferences = new List<Preference__c> {
            new Preference__c(Student__c = students[0].Id, Skill__c = skills[0].Id),
            new Preference__c(Student__c = students[0].Id, Skill__c = skills[2].Id)
        };
        insert preferences;

        List<Discipline__c> disciplines = new List<Discipline__c> {
            new Discipline__c(Course__c = courses[0].Id, Skill__c = skills[1].Id),
            new Discipline__c(Course__c = courses[0].Id, Skill__c = skills[2].Id),
            new Discipline__c(Course__c = courses[1].Id, Skill__c = skills[0].Id),
            new Discipline__c(Course__c = courses[1].Id, Skill__c = skills[1].Id),
            new Discipline__c(Course__c = courses[1].Id, Skill__c = skills[2].Id)
        };
        insert disciplines;

    }

    @isTest
    static void testGetMatchPercentage() {
        Decimal d = 100;
        d.setScale(2);

        List<Student__c> students = new List<Student__c>([SELECT Id, Name FROM Student__c]);


        Test.startTest();
        Map<String, List<StudentCourses.StudentCourse>> results = StudentCourses.getMatchPercent(students);
        Test.stopTest();

        System.assertEquals(true, results.containsKey('TestStudent'));
        System.assertEquals(d, results.get('TestStudent').get(0).matchPercentage);
        System.assertEquals((d / 2), results.get('TestStudent').get(1).matchPercentage);
    }
}