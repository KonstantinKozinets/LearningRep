public class StudentCourses {

    public class StudentCourse implements Comparable {
        public String cName;
        public Double matchPercentage;

        public StudentCourse (String courseName, Decimal matchPercent) {
            cName = courseName;
            matchPercentage = matchPercent;
        }

        public Integer compareTo(Object compareTo) {

            StudentCourse compareToStudentCourse = (StudentCourse)compareTo;

            if (matchPercentage > compareToStudentCourse.matchPercentage) {
                return -1;
            } else if (matchPercentage < compareToStudentCourse.matchPercentage) {
                return 1;
            } else {
                return 0;
            }
        }
    }

    public static Map<Id, Student__c> getStudents {
        get{
            if (getStudents == null) {
                Map<Id, Student__c> students = new Map<Id,Student__c> ([
                    SELECT Id, Name
                    FROM Student__c
                ]);
                getStudents = students;
            }

            return getStudents;
        }
        private set;
    }

    public static Map<Id, Course__c> getCourses {
        get{
            if (getCourses == null) {
                Map<Id, Course__c> courses = new Map<Id,Course__c>([
                    SELECT Id, Name
                    FROM Course__c
                ]);
                getCourses = courses;
            }

            return getCourses;
        }
        private set;
    }

    public static Map<String, Set<Id>> getPreferences {
        get {
            if (getPreferences == null) {
                Map<Id, Preference__c> prefs = new Map<Id, Preference__c>([
                    SELECT Student__r.Name, Skill__c
                    FROM Preference__c
                ]);

                getPreferences = new Map<String, Set<Id>>();

                for(Student__c std : getStudents.values()) {
                    getPreferences.put(std.Name, new Set<Id>());

                    for (Preference__c pref : prefs.values()) {
                        if (getPreferences.containsKey(pref.Student__r.Name)) {
                            getPreferences.get(pref.Student__r.Name).add(pref.Skill__c);
                        }
                    }
                }
            }

            return getPreferences;
        }
        private set;
    }

    public static Map<String, Set<Id>> getDisciplines {
        get {
            if (getDisciplines == null) {
                Map<Id, Discipline__c> courses = new Map<Id, Discipline__c>([
                    SELECT Course__r.Name, Skill__c
                    FROM Discipline__c
                ]);

                getDisciplines = new Map<String, Set<Id>>();

                for(Course__c crs : getCourses.values()) {
                    getDisciplines.put(crs.Name, new Set<Id>());
                    for (Discipline__c dis : courses.values()) {
                        if (getDisciplines.containsKey(dis.Course__r.Name)) {
                            getDisciplines.get(dis.Course__r.Name).add(dis.Skill__c);
                        }
                    }
                }
            }
            return getDisciplines;
        }
        private set;
    }

    public static Decimal getMatchPercent(String course, String student) {

        Set<Id> disciplines = getDisciplines.get(course);
        Set<Id> preferences = getPreferences.get(student);
        Decimal matchPercent = 0;

        for (Id d : disciplines) {
            if (preferences.contains(d)) {
                matchPercent++;
            }
        }

        if (!preferences.isEmpty()) {
            matchPercent = matchPercent / preferences.size() * 100;
        }

        return matchPercent.setScale(2);
    }

    public static Map<String, List<StudentCourse>> getMatchPercent(List<Student__c> students) {

        Map<String, List<StudentCourse>> resultMap = new Map<String, List<StudentCourse>>();

        for (Student__c student : students) {
            if (getPreferences.containsKey(student.Name)) {
                resultMap.put(student.Name, new List<StudentCourse>());

                for (String course : getDisciplines.keySet()) {
                    resultMap.get(student.Name).add(
                        new StudentCourse(course, getMatchPercent(course, student.Name))
                    );
                }

                resultMap.get(student.Name).sort();
            }
        }

        return resultMap;
    }


}