messages = 'Hello World'
# Integers
# Floats
# constants
print(messages)
age_new = [10, 20, 30]
print(type(age_new))
person_details = {
    'name': 'Kofi',
    'Programme': 'Computer Science',
    'Level': 200,
}

age = 17

if age < 18:
    print("You're mot eligible to vote")
else:
    print("You're eligible to vote")


# functions
def test(*args):
    print(args)


# generators
def gen(*args):
    for arg in args:
        yield arg


val = gen(1, 2, 3, 4, 5, 6)
for v in val:
    print(v)
