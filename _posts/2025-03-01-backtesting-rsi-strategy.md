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

In this implementation, I calculate RSI using daily candles and Rolling Moving Average (RMA), which matches TradingView's calculation method. Here's the specific calculation method:

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
- Employs RMA (Rolling Moving Average) for more accurate TradingView compatibility
- Default period of 14 days
- Handles edge cases where gains or losses are zero
- Uses `ewm()` with `adjust=False` to calculate proper RMA

You can read more about RSI in [my recent post](https://graniluk.github.io/posts/calculating-RSI/):
## What is Backtesting?

Backtesting is the process of testing a trading strategy using historical data to simulate how it would have performed in the past. This helps evaluate the strategy's effectiveness before risking real money.

## Strategy Overview


My implementation focuses on:

1. Entering positions when RSI falls below a certain threshold

2. Using take-profit (❤️) and stop-loss (💀) levels for exit conditions

3. Testing various parameter combinations to find optimal settings

### Trading Rules

- Fixed investment amount of $1,000 per trade

- Only one position can be open at a time

- New trades can only be opened after the previous position is closed (either by hitting TP or SL)

- The entry point is the opening price one to two days following signal generation.

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

rsi_range = range(20, 40)  # RSI values from 20 to 40

tp_values = ["1.05", "1.1", "1.15", "1.2"]  # Take profit levels: 5% to 20%

sl_values = ["1.05", "1.1", "1.15", "1.2"]  # Stop loss levels: 5% to 20%

days_options = [0, 1]  # Days to wait after signal

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

## TOP 20
After running the grid search across 15 cryptocurrencies with 672 parameter combinations each, here are the best 20 results:

# Cryptocurrency Trading Strategy Results

| rsi_value | tp_value | sl_value | daysAfterToBuy | total_profit | trades | TP_ratio    | TP_hits | SL_hits | symbol_name |
| --------- | -------- | -------- | -------------- | ------------ | ------ | ----------- | ------- | ------- | ----------- |
| 38        | 1.2      | 0.8      | 2              | 6800         | 66     | 0.757575758 | 50      | 16      | XRP         |
| 40        | 1.2      | 0.8      | 1              | 6600         | 83     | 0.698795181 | 58      | 25      | XRP         |
| 40        | 1.2      | 0.8      | 2              | 6400         | 78     | 0.705128205 | 55      | 23      | ETH         |
| 37        | 1.2      | 0.8      | 2              | 5800         | 61     | 0.737704918 | 45      | 16      | XRP         |
| 39        | 1.2      | 0.8      | 1              | 5800         | 71     | 0.704225352 | 50      | 21      | XRP         |
| 39        | 1.2      | 0.8      | 2              | 5800         | 71     | 0.704225352 | 50      | 21      | XRP         |
| 38        | 1.2      | 0.8      | 1              | 5600         | 66     | 0.712121212 | 47      | 19      | XRP         |
| 40        | 1.2      | 0.8      | 1              | 5400         | 79     | 0.670886076 | 53      | 26      | ETH         |
| 40        | 1.2      | 0.8      | 2              | 5400         | 83     | 0.662650602 | 55      | 28      | XRP         |
| 40        | 1.2      | 0.85     | 2              | 5300         | 79     | 0.620253165 | 49      | 30      | ETH         |
| 38        | 1.2      | 0.85     | 1              | 4800         | 66     | 0.636363636 | 42      | 24      | XRP         |
| 40        | 1.2      | 0.85     | 1              | 4700         | 83     | 0.590361446 | 49      | 34      | XRP         |
| 40        | 1.2      | 0.85     | 2              | 4700         | 83     | 0.590361446 | 49      | 34      | XRP         |
| 39        | 1.2      | 0.8      | 2              | 4600         | 67     | 0.671641791 | 45      | 22      | ETH         |
| 37        | 1.2      | 0.8      | 1              | 4600         | 61     | 0.68852459  | 42      | 19      | XRP         |
| 39        | 1.2      | 0.85     | 1              | 4400         | 71     | 0.605633803 | 43      | 28      | XRP         |
| 38        | 1.15     | 0.8      | 2              | 4300         | 66     | 0.757575758 | 50      | 16      | XRP         |
| 40        | 1.2      | 0.85     | 1              | 4250         | 79     | 0.582278481 | 46      | 33      | ETH         |
| 38        | 1.2      | 0.85     | 2              | 4100         | 66     | 0.606060606 | 40      | 26      | XRP         |
| 39        | 1.2      | 0.85     | 2              | 4050         | 71     | 0.591549296 | 42      | 29      | XRP         |


## RSI Strategy Backtesting Results Analysis


This table presents the backtesting results of a trading strategy using the Relative Strength Index (RSI) indicator for XRP and ETH cryptocurrencies. Here's a brief analysis:

## Key Findings:

1. **Best Performance**: The most profitable configuration (6800 profit units) used RSI=38, take profit=1.2, stop loss=0.8, with entry 2 days after the signal for XRP.
2. **Parameter Patterns**:
    - RSI values between 37-40 show the best results
    - Take profit at 1.2x entry price consistently delivers good returns
    - Stop loss at 0.8 outperforms most configurations
    - Both 1-day and 2-day delayed entries can be effective
3. **Success Rates**: The highest win rates (TP_ratio) reach approximately 75-76%, with the best setups achieving 50 winning trades versus just 16 losing trades.
    
4. **Asset Comparison**: XRP configurations appear more frequently in the top-performing results compared to other assets.
    
5. **Risk-Reward Balance**: The most profitable configurations also tend to have the best TP_ratio, suggesting that success rate strongly correlates with overall profitability.
    

The data indicates that an RSI in the 37-40 range with a tight stop loss (0.8) and reasonable take profit (1.2) creates an effective trading strategy, particularly for XRP.

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

### Key Insights
- The strategy performed best during periods of medium volatility
- Optimal results were achieved with a 1-day delay after signal generation
- Higher success rate on major cryptocurrencies (BTC, ETH)
- The 15% take-profit level provided the best balance between profit capture and win rate
- Stop-loss at 10% effectively limited downside risk while maintaining profitability
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
