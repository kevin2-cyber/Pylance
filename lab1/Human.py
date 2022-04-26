class Human:

    def __init__(self, name, hands, legs, eyes):
        self.name = name
        self.hands = hands
        self.legs = legs
        self.eyes = eyes

    def walk(self):
        if self.legs == 2:
            print("I can walk")
        else:
            print("Sorry I can't walk")


firstPerson = Human("Adam", 2, 7, 5)
secondPerson = Human("Eve", 2, 2, 2)

