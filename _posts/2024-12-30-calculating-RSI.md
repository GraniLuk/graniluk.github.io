---
title: Understanding RSI and Its Application in Technical Analysis
date: 2024-12-30 12:00:00 +0100
categories: [Trading, Technical Analysis]
tags: [trading, technical analysis, RSI, Indicators, python]
image:
  path: /assets/img/week202450/technicalAnalysis.png
  alt: code blocks
---

# Understanding RSI and Its Application in Technical Analysis

The Relative Strength Index (RSI) is a momentum oscillator that measures the speed and change of price movements. It is used in technical analysis to identify overbought or oversold conditions in a market. RSI values range from 0 to 100, with high values indicating overbought conditions and low values indicating oversold conditions.

## Identifying Overbought and Oversold Conditions

RSI's primary function is to indicate overbought or oversold market conditions:
**Overbought**: When RSI rises above 70, it suggests the asset may be overvalued and due for a potential price correction.
**Oversold**: When RSI falls below 30, it indicates the asset might be undervalued and could experience a price increase.

However, during strong trends, RSI can remain in overbought or oversold territory for extended periods.

## How RSI is Calculated

RSI can be calculated using different methods. Below are three common approaches:

### 1. Standard RSI Calculation

The standard RSI calculation involves the following steps:
1. Calculate the price changes (delta) between consecutive closing prices.
2. Separate the gains (positive changes) and losses (negative changes).
3. Calculate the average gain and average loss over a specified period (typically 14 days).
4. Compute the Relative Strength (RS) as the ratio of average gain to average loss.
5. Calculate the RSI using the formula: `RSI = 100 - (100 / (1 + RS))`.

Here is a Python function to calculate the standard RSI:

```python
def calculate_rsi(series, window=14):
    delta = series.diff()
    gain = (delta.where(delta > 0, 0)).rolling(window=window).mean()
    loss = (-delta.where(delta < 0, 0)).rolling(window=window).mean()
    rs = gain / loss
    rsi = 100 - (100 / (1 + rs))
    return rsi
```

### 2. RSI Using Exponential Moving Average (EMA)

This method uses the Exponential Moving Average (EMA) to smooth the gains and losses:

```python
def calculate_rsi_using_EMA(series, period=14):
    delta = series.diff()
    gain = delta.where(delta > 0, 0)
    loss = -delta.where(delta < 0, 0)
    avg_gain = calculate_ema(gain, period)
    avg_loss = calculate_ema(loss, period)
    rs = avg_gain / avg_loss
    rsi = 100 - (100 / (1 + rs))
    return rsi

def calculate_ema(series, period):
    return series.ewm(span=period, adjust=False).mean()
```

### 3. RSI Using Relative Moving Average (RMA)

The RMA method uses a different smoothing technique:

```python
def calculate_rsi_using_RMA(series, periods=14):
    delta = series.diff()
    gain = delta.where(delta > 0, 0)
    loss = -delta.where(delta < 0, 0)
    alpha = 1.0 / periods
    avg_gain = gain.ewm(alpha=alpha, adjust=False).mean()
    avg_loss = loss.ewm(alpha=alpha, adjust=False).mean()
    rs = avg_gain / avg_loss
    rsi = 100 - (100 / (1 + rs))
    return rsi
```

## Fetching Data and Calculating RSI

To calculate RSI for different symbols, we can fetch historical price data from exchanges like Kucoin and Binance. Below are functions to fetch closing prices and calculate RSI:

```python
def fetch_close_prices_from_Kucoin(symbol: str, limit: int = 14) -> pd.DataFrame:
    # Implementation to fetch data from Kucoin
    pass

def fetch_close_prices_from_Binance(symbol: str, lookback_days: int = 14) -> pd.DataFrame:
    # Implementation to fetch data from Binance
    pass

def create_rsi_table(symbols: List[Symbol]) -> PrettyTable:
    all_values = pd.DataFrame()
    for symbol in symbols:
        try:
            if symbol.symbol_name in KUCOIN_SYMBOLS:
                df = fetch_close_prices_from_Kucoin(symbol.kucoin_name)
            else:
                df = fetch_close_prices_from_Binance(symbol.binance_name)
            if not df.empty:
                df['RSI'] = calculate_rsi_using_EMA(df['close'])
                df['symbol'] = symbol.symbol_name
                latest_row = df.iloc[-1:]
                all_values = pd.concat([all_values, latest_row])
        except Exception as e:
            app_logger.error(f"Error processing {symbol.symbol_name}: {str(e)}")
    all_values = all_values.sort_values('RSI', ascending=False)
    rsi_table = PrettyTable()
    rsi_table.field_names = ["Symbol", "Current Price", "RSI"]
    for _, row in all_values.iterrows():
        symbol = row['symbol']
        price = float(row['close'])
        rsi = float(row['RSI'])
        rsi_table.add_row([symbol, f"${price:,.2f}", f"{rsi:.2f}"])
    return rsi_table
```

## Conclusion

RSI is a valuable tool in technical analysis, helping traders identify potential buy or sell opportunities. By using different calculation methods, traders can gain insights into market conditions and make informed decisions.

```
