---
title: Backtesting RSI strategy
date: 2025-03-01 12:00:00 +0100
categories: [Trading, Technical Analysis]
tags: [trading, technical analysis, RSI, Indicators, python]
image:
  path: /assets/img/week202450/technicalAnalysis.png
  alt: code blocks
---

## Introduction

In this post, I'll share my Python script for backtesting a trading strategy based on the Relative Strength Index (RSI). We'll explore the implementation, methodology, and results of testing this strategy across multiple cryptocurrency symbols.

## What is RSI?

The Relative Strength Index (RSI) is a momentum oscillator that measures the speed and magnitude of recent price changes to evaluate overbought or oversold conditions. It oscillates between 0 and 100, with traditional interpretation considering:
- RSI > 70: Potentially overbought
- RSI < 30: Potentially oversold

### RSI Calculation Details

In this implementation, I calculate RSI using daily candles and Exponential Moving Average (EMA). Here's the specific calculation method:

```python
def calculate_rsi_using_EMA(series, period=14):
    # Calculate price changes
    delta = series.diff()

    # Separate gains and losses
    gain = delta.where(delta > 0, 0)
    loss = -delta.where(delta < 0, 0)

    # Calculate EMA of gains and losses
    avg_gain = calculate_ema(gain, period)
    avg_loss = calculate_ema(loss, period)

    # Calculate RS
    rs = avg_gain / avg_loss

    # Calculate RSI
    rsi = 100 - (100 / (1 + rs))
    return rsi
```

Key aspects of this implementation:
- Uses daily closing prices
- Employs EMA instead of simple moving average (SMA)
- Default period of 14 days
- Smooths gains and losses using EMA for more responsive signals

You can read more about RSI in [my recent post](https://graniluk.github.io/posts/calculating-RSI/): 

## What is Backtesting?

Backtesting is the process of testing a trading strategy using historical data to simulate how it would have performed in the past. This helps evaluate the strategy's effectiveness before risking real money.

## Strategy Overview

My implementation focuses on:
1. Entering positions when RSI falls below a certain threshold
2. Using take-profit (TP) and stop-loss (SL) levels for exit conditions
3. Testing various parameter combinations to find optimal settings

### Trading Rules
- Fixed investment amount of $1,000 per trade
- Only one position can be open at a time
- New trades can only be opened after the previous position is closed (either by hitting TP or SL)
- Entry occurs on the next day's opening price after a signal is generated

## Testing Parameters and Data Scope

### Data Coverage
The backtesting was performed on 15 different cryptocurrencies:
- Major Cryptocurrencies: BTC, ETH, XRP, SOL, DOT
- DeFi & Ecosystem Tokens: ATOM, TON, OSMO
- Exchange: KCS, NEXO
- Layer 1 & 2 Solutions: HBAR, FLOW
- Emerging Projects: AKT, DYM, VIRTUAL

For each cryptocurrency, I analyzed daily candles from the last 5 years, providing a comprehensive dataset across different market conditions.

### Parameter Ranges
The strategy was tested across multiple parameter combinations:

```python
# Parameter ranges for grid search
rsi_range = range(20, 41)  # RSI values from 20 to 40
tp_values = ["1.05", "1.1", "1.15", "1.2"]  # Take profit levels: 5% to 20%
sl_values = ["1.05", "1.1", "1.15", "1.2"]  # Stop loss levels: 5% to 20%
days_options = [0, 1]  # Days to wait after signal
```

This comprehensive grid search resulted in testing:
- 21 different RSI values
- 4 take-profit levels
- 4 stop-loss levels
- 2 timing options
- Total combinations per cryptocurrency: 672

## Key Components of the Script

### Trade Signal Generation

```python
# Signal generation based on RSI
df["signal"] = (df["RSI"] <= rsi_value) & (df["RSI"].shift(1) > rsi_value)
```

This code identifies entry points when RSI crosses below our threshold.

### Trade Management

```python
# Trade execution with TP/SL
tp_price = entry_price * tp_value
sl_price = entry_price * sl_value

if current_high >= tp_price:
    outcome = "TP"
    close_price = current_high
elif current_low <= sl_price:
    outcome = "SL"
    close_price = current_low
```

Each trade is managed with predefined take-profit and stop-loss levels.

### Grid Search Implementation

```python
def run_grid_search_for_symbol(conn, symbol):
    rsi_range = range(20, 41)  # 20 to 40 inclusive
    tp_values = [Decimal(val) for val in ["1.05", "1.1", "1.15", "1.2"]]
    sl_values = [Decimal(val) for val in ["1.05", "1.1", "1.15", "1.2"]]
    days_options = [0, 1]
```

The grid search tests multiple parameter combinations to find the most profitable settings.

## Results

(Here you can add your actual backtest results)

### Best Performing Parameters
- RSI Value: XX
- Take Profit: XX%
- Stop Loss: XX%
- Days After Signal: X

### Performance Metrics
- Total Trades: XX
- Win Rate: XX%
- Average Profit per Trade: $XX
- Maximum Drawdown: XX%

## Conclusions

(Add your conclusions based on the actual results)

## Future Improvements

Potential enhancements to consider:
1. Adding more technical indicators
2. Implementing position sizing
3. Including trading fees in calculations
4. Testing across different market conditions

## Code Repository

The complete code is available in my GitHub repository. Feel free to use it and adapt it to your needs!

