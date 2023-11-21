import unittest
from cpu import Robot

class TestRobot(unittest.TestCase):
    def setUp(self):
        self.robot = Robot()

    def test_initial_position(self):
        self.assertEqual((self.robot.x, self.robot.y), (0, 0))

    def test_move_within_bounds(self):
        self.robot.move(2)
        self.assertEqual((self.robot.x, self.robot.y), (0, 2))

    def test_turn(self):
        self.robot.turn(90)
        self.assertEqual(self.robot.orientation, 90)

    def test_error_out_of_bounds(self):
        with self.assertRaises(ValueError):
            self.robot.move(5)

if __name__ == '__main__':
    unittest.main()
