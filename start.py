import MetaTrader5 as mt5
import time

# connect to MT5
if not mt5.initialize():
    print("initialize() failed, error code =", mt5.last_error())
    quit()

# get the latest candlestick data for EURUSD
symbol = "EURUSD"
timeframe = mt5.TIMEFRAME_M15
eurusd_rates = mt5.copy_rates_from(symbol, timeframe, 0, 8)

# calculate the average price for each candle
for i in range(len(eurusd_rates)):
    open_price = eurusd_rates[i][1]
    high_price = eurusd_rates[i][2]
    low_price = eurusd_rates[i][3]
    close_price = eurusd_rates[i][4]
    avg_price = (open_price + high_price + low_price + close_price) / 4
    print(f"Average price for candle {i}: {avg_price:.5f}")

# shutdown MT5
mt5.shutdown()
