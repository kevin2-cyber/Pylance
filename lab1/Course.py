class Course:

    def __init__(self, name, courseCode, creditHours):
        self.name = name
        self.courseCode = courseCode
        self.creditHours = creditHours


class Student:

    def __init__(self, name, id):
        self.name = []
        self.id = []
        self.courses = []

    def add_course(self, course):
        self.courses.append(course)

    def add_name(self, name):
        self.name.append()

    def print_proof(self):
        for course in self.courses:
            print(course)


dcit_201 = Course("Prog. 1", "DCIT 201", 3)
student1 = Student("Kofi", "10223")
student1.add_course(dcit_201.courseCode)
student1.print_proof()
