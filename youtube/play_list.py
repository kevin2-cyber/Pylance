num = input("Enter number")
num = int(num)
sum = 0
average = 0
for i in range(2, num + 1):
    for j in range(2, i):
        if (i % j == 0):
            break
    else:
        print(i)
        sum = sum + i
        average = sum / i
print("Sum of prime number is", sum)
print("average is", average)
