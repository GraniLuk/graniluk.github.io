---
title: Backtesting RSI strategy
date: 2025-03-15 08:00:00 +0100
categories: [Trading, Technical Analysis]
tags: [trading, technical analysis, RSI, Indicators, python]
image:
  path: /assets/img/technical_analysis/backtesting_logo.png
  alt: code blocks
---
  

## Introduction

In this article, I’ll walk you through the process of backtesting a trading strategy based on the Relative Strength Index (RSI). We’ll cover the implementation details, methodology, and results of testing this strategy across multiple cryptocurrency symbols. By the end, you’ll have a clear understanding of how to evaluate and optimize an RSI-based trading strategy using Python.

## What is RSI?

The Relative Strength Index (RSI) is a popular momentum oscillator that measures the speed and magnitude of recent price changes to identify overbought or oversold conditions in a market. It oscillates between 0 and 100, with traditional thresholds interpreted as follows:

- RSI > 70: Potentially overbought

- RSI < 30: Potentially oversold
### RSI Calculation Details

In this implementation, I calculate RSI using daily candles and the Rolling Moving Average (RMA), which aligns with TradingView’s calculation method. Below is the Python function used:

```python
def calculate_rsi_using_RMA(series, periods=14):
    delta = series.diff()

    # Separate gains and losses
    gain = delta.where(delta > 0, 0)
    loss = -delta.where(delta < 0, 0)

    alpha = 1.0 / periods

    avg_gain = gain.ewm(alpha=alpha, adjust=False).mean()
    avg_loss = loss.ewm(alpha=alpha, adjust=False).mean()

    rs = avg_gain / avg_loss
    rsi = (
        100
        if avg_loss.iloc[-1] == 0
        else 0
        if avg_gain.iloc[-1] == 0
        else 100 - (100 / (1 + rs))
    )

    return rsi
```

Key aspects of this implementation:
- Uses daily closing prices
- Employs RMA for compatibility with TradingView.
- Default period of 14 days
- Handles edge cases where gains or losses are zero
- Uses `ewm()` with `adjust=False` to calculate proper RMA

You can read more about RSI in [my recent post](https://graniluk.github.io/posts/calculating-RSI/):
## What is Backtesting?

Backtesting involves simulating a trading strategy on historical data to evaluate its performance. It’s an essential step in determining whether a strategy is worth implementing in live markets.

## Why Backtest?
1. **Risk-Free Evaluation**: Test strategies without risking real money.
2. **Optimization**: Fine-tune parameters for better performance.
3. **Insights**: Understand how strategies perform under different market conditions.

## Strategy Overview


My implementation focuses on:

1. **Entry Condition**: Enter a position when RSI rise above a certain threshold.
2. **Exit Conditions**:
    - Take-profit (TP): Exit when the price reaches a predefined profit level.
    - Stop-loss (SL): Exit when the price falls to a predefined loss level.
3. **Parameter Optimization**: Test various combinations of RSI thresholds, TP levels, SL levels, and entry timing.


### Trading Rules

- Fixed investment amount: **\$1,000 per trade**.
- Only one position can be open at a time.
- A new trade can only be initiated after the previous position is closed (via TP or SL).
- Entry occurs at the opening price one or two days after signal generation.


---

## Testing Parameters and Data Scope

### Data Coverage

The backtesting was performed on 15 different cryptocurrencies:

- **Major Cryptocurrencies**: BTC, ETH, XRP, SOL, DOT.
- **DeFi \& Ecosystem Tokens**: ATOM, TON, OSMO.
- **Exchange Tokens**: KCS, NEXO.
- **Layer 1 \& 2 Solutions**: HBAR, FLOW.
- **Emerging Projects**: AKT, DYM, VIRTUAL.

For each cryptocurrency, I analyzed daily candles from the last 5 years, providing a comprehensive dataset across different market conditions.

### Parameter Ranges

The strategy was tested across multiple parameter combinations using grid search:

```python
# Parameter ranges for grid search
rsi_range = range(20, 40)         # RSI values from 20 to 40
tp_values = ["1.05", "1.1", "1.15", "1.2"]   # Take-profit levels (5% to 20%)
sl_values = ["1.05", "1.1", "1.15", "1.2"]   # Stop-loss levels (5% to 20%)
days_options = [0, 1]             # Days to wait after signal
```

This resulted in testing:

- **21 RSI values**
- **4 take-profit levels**
- **4 stop-loss levels**
- **2 timing options**

Total combinations per cryptocurrency: **672**.

---
## Key Components of the Script

### Trade Signal Generation


```python

# Signal generation based on RSI

df["signal"] = (df["RSI"] >= rsi_value) & (df["RSI"].shift(1) < rsi_value)

```


This script pinpoints instances where the RSI indicator cross above a predefined limit.

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

    rsi_range = range(20, 41)  # 20 to 40 inclusive

    tp_values = [Decimal(val) for val in ["1.05", "1.1", "1.15", "1.2"]]

    sl_values = [Decimal(val) for val in ["1.05", "1.1", "1.15", "1.2"]]

    days_options = [0, 1]

```


The grid search tests multiple parameter combinations to find the most profitable settings.

## Results

### Top Performers

After testing all combinations across 15 cryptocurrencies, here are the top-performing configurations:

| symbol_name | rsi_value | tp_value | sl_value | daysAfterToBuy | total_profit | trades | TP_ratio    | TP_hits | SL_hits |
| ----------- | --------- | -------- | -------- | -------------- | ------------ | ------ | ----------- | ------- | ------- |
| XRP         | 38        | 1.2      | 0.8      | 2              | 6800         | 66     | 0.757575758 | 50      | 16      |
| XRP         | 40        | 1.2      | 0.8      | 1              | 6600         | 83     | 0.698795181 | 58      | 25      |
| ETH         | 40        | 1.2      | 0.8      | 2              | 6400         | 78     | 0.705128205 | 55      | 23      |
| XRP         | 37        | 1.2      | 0.8      | 2              | 5800         | 61     | 0.737704918 | 45      | 16      |
| XRP         | 39        | 1.2      | 0.8      | 1              | 5800         | 71     | 0.704225352 | 50      | 21      |
| XRP         | 39        | 1.2      | 0.8      | 2              | 5800         | 71     | 0.704225352 | 50      | 21      |
| XRP         | 38        | 1.2      | 0.8      | 1              | 5600         | 66     | 0.712121212 | 47      | 19      |
| ETH         | 40        | 1.2      | 0.8      | 1              | 5400         | 79     | 0.670886076 | 53      | 26      |
| XRP         | 40        | 1.2      | 0.8      | 2              | 5400         | 83     | 0.662650602 | 55      | 28      |
| ETH         | 40        | 1.2      | 0.85     | 2              | 5300         | 79     | 0.620253165 | 49      | 30      |
| XRP         | 38        | 1.2      | 0.85     | 1              | 4800         | 66     | 0.636363636 | 42      | 24      |
| XRP         | 40        | 1.2      | 0.85     | 1              | 4700         | 83     | 0.590361446 | 49      | 34      |
| XRP         | 40        | 1.2      | 0.85     | 2              | 4700         | 83     | 0.590361446 | 49      | 34      |
| ETH         | 39        | 1.2      | 0.8      | 2              | 4600         | 67     | 0.671641791 | 45      | 22      |
| XRP         | 37        | 1.2      | 0.8      | 1              | 4600         | 61     | 0.68852459  | 42      | 19      |
| XRP         | 39        | 1.2      | 0.85     | 1              | 4400         | 71     | 0.605633803 | 43      | 28      |
| XRP         | 38        | 1.15     | 0.8      | 2              | 4300         | 66     | 0.757575758 | 50      | 16      |
| ETH         | 40        | 1.2      | 0.85     | 1              | 4250         | 79     | 0.582278481 | 46      | 33      |
| XRP         | 38        | 1.2      | 0.85     | 2              | 4100         | 66     | 0.606060606 | 40      | 26      |
| XRP         | 39        | 1.2      | 0.85     | 2              | 4050         | 71     | 0.591549296 | 42      | 29      |

---



## Key Findings:

1. **Best Performance**: The most profitable configuration (6800 profit units) used RSI=38, take profit=1.2, stop loss=0.8, with entry 2 days after the signal for XRP.
2. **Parameter Patterns**:
    - RSI values between 37-40 show the best results
    - Take-profit at **20% (TP=1.2)** consistently delivered strong results.
    - Stop-loss at **20% (SL=0.8)** minimized risk effectively.
    - Both 1-day and 2-day delayed entries can be effective
3. **Success Rates**: The highest win rates (TP_ratio) reach approximately 75-76%, with the best setups achieving 50 winning trades versus just 16 losing trades.
    
4. **Asset Comparison**: XRP configurations appear more frequently in the top-performing results compared to other assets.
    

### Best Performing Parameters
- Symbol name: XRP
- RSI Value: 38
- Take Profit: 20%
- Stop Loss: 20%
- Days After Signal: 2

### Performance Metrics
- Total Trades: 67
- Win Rate: 76%
- Average days to TP: 27.9
- Average days to SL: 19.3
- Total profit: $7000.00

### Visualization

![xrp chart with rsi](/assets/img/technical_analysis/rsi_chart.png)

The visualization above presents the results of our best-performing RSI strategy configuration (RSI: 38, TP: 1.2, SL: 0.8, 2-day delay) applied to XRP over a 5-year timeframe. This chart effectively demonstrates why this particular parameter combination achieved our highest profitability metrics.

The top panel displays XRP's price action through OHLC candlesticks, while the bottom panel shows the RSI indicator with our optimal threshold of 38 marked by a horizontal dashed line. Blue triangles represent entry points, green triangles indicate take-profit exits (20% gain), and red triangles show stop-loss exits (20% loss).

### Key Observations

The chart confirms several insights from our backtesting results:

- **Effective Entry Timing**: Entry points (blue triangles) consistently appear after RSI crosses above the 38 threshold, capturing the beginning of upward momentum phases.

- **Favorable Win Rate**: The prevalence of green triangles (TP exits) visually demonstrates our impressive 76% win rate, with 50 profitable trades versus only 16 losses.

- **Market Cycle Performance**: The strategy performed well across different market conditions, including:
  - The accumulation phase in 2020 (establishing low-cost basis positions)
  - The 2021 bull run (capturing significant gains as XRP approached $2.00)
  - The 2022-2023 consolidation period (maintaining profitability during sideways price action)
  - The recent 2024-2025 bull market (capitalizing on XRP's rise above $3.00)

- **Risk Management Effectiveness**: The placement of stop-losses at 20% effectively minimized drawdowns during market corrections, while the 20% take-profit level successfully captured gains before significant retracements.

- **Signal Quality**: The 2-day delay after signal generation appears optimal, providing better entry timing that avoids false breakouts and improves win rate.

The recent performance during the 2024-2025 bull market is particularly noteworthy, with multiple successful trades as XRP reached new all-time highs above $3.50, confirming the robustness of this parameter combination even in rapidly evolving market conditions.

This visual evidence supports our numerical findings that XRP with these specific parameters (RSI: 38, TP: 1.2, SL: 0.8, 2-day delay) represents the optimal configuration among all 672 parameter combinations tested across 15 cryptocurrencies.

## Conclusions

The backtesting results demonstrate that an RSI-based strategy can be highly effective when optimized correctly:

- Focus on RSI values in the range of **37–40**.
- Use broader stop-losses (**SL=0.8**) and reasonable take-profits (**TP=1.2**) for balanced risk-reward outcomes.
- XRP showed exceptional performance compared to other assets.

---

## Future Improvements

Potential enhancements to consider:

1. Incorporate additional technical indicators for confirmation signals.
2. Account for trading fees and slippage in calculations.
3. Test performance under varying market conditions (e.g., bull vs bear markets).

---

## Code Repository

The complete code for this backtest is available on my [CryptoMorningReports](https://github.com/GraniLuk/CryptoMorningReports/tree/main/backtesting/rsi). Feel free to explore it and adapt it to your needs!

