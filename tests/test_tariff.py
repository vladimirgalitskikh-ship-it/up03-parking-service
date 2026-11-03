import unittest
from decimal import Decimal
from src.tariff import calculate_cost
class TariffTests(unittest.TestCase):
    def test_round_up(self): self.assertEqual(calculate_cost(130,60,100),Decimal("300.00"))
    def test_exact_hour(self): self.assertEqual(calculate_cost(60,60,100),Decimal("100.00"))
    def test_zero(self): self.assertEqual(calculate_cost(0,60,100),Decimal("0.00"))
    def test_negative(self):
        with self.assertRaises(ValueError): calculate_cost(-1,60,100)
