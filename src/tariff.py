from decimal import Decimal, ROUND_CEILING

def calculate_cost(minutes, unit_minutes, rate):
    if minutes < 0 or unit_minutes <= 0 or Decimal(str(rate)) < 0:
        raise ValueError("Invalid duration or rate")
    units = (Decimal(str(minutes)) / Decimal(str(unit_minutes))).to_integral_value(rounding=ROUND_CEILING)
    return (units * Decimal(str(rate))).quantize(Decimal("0.01"))
