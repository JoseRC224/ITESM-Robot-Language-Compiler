import csv
import numpy as np

class Robot:
    def __init__(self):
        self.x = 0
        self.y = 0
        self.orientation = 0  # Representa la orientación en grados (0, 90, 180, 270)
        self.map = np.zeros(shape=(4,4))  # Campo de juego 4x4

    def move(self, steps):
        if self.orientation == 0:  # Norte
            self.y += steps
        elif self.orientation == 180:  # Sur
            self.y -= steps
        elif self.orientation == 90:  # Este
            self.x += steps
        elif self.orientation == 270:  # Oeste
            self.x -= steps

        # Comprobación de límites
        if not (0 <= self.x < 4 and 0 <= self.y < 4):
            raise ValueError("Movimiento fuera de límites")

    def turn(self, degrees):
        self.orientation = (self.orientation + degrees) % 360

def do_instruction(robot, inst):
    command, value = inst
    if command == "mov":
        robot.move(int(value))
    elif command == "turn":
        robot.turn(int(value))
    print(f"Posición: ({robot.x}, {robot.y}), Orientación: {robot.orientation}")
    print(robot.map)

def read_file():
    inst_list = []
    with open('instructions.asm') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        for row in csv_reader:
            inst_list.append(row)
    return inst_list

def main():
    robot = Robot()
    inst_list = read_file()
    for inst in inst_list:
        try:
            do_instruction(robot, inst)
        except ValueError as e:
            print(e)
            break

if __name__ == "__main__":
    main()
