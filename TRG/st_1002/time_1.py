from datetime import datetime, timedelta

start = input("Write 'start' to recalculate time: ").lower()

time_measurement = []

if start == 'start':
    beginning = input("Enter the beginning time (HH:MM:SS.SS): ")
    try:
        time_beginning = datetime.strptime(beginning, "%H:%M:%S.%f")
    except ValueError:
        print("Invalid format for beginning time.")
        exit()

    while True:
        time_input = input("Enter the time difference (HH:MM:SS.SS), or type 'end' to stop: ")
        if time_input.lower() == "end":
            break
        try:
            time_difference = datetime.strptime(time_input, "%H:%M:%S.%f") - datetime.strptime("00:00:00.00", "%H:%M:%S.%f")
            result_time = time_beginning + time_difference
            time_measurement.append(result_time)
        except ValueError:
            print("Invalid format. Please use HH:MM:SS.SS.")
            continue

if time_measurement:
    with open("time_measurements.txt", "w") as file:
        for measurement in time_measurement:
            file.write(f"{measurement.strftime('%H:%M:%S.%f')}\n")

print("Time recalculation ended")
