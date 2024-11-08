---
title: Return Value Displayed in Debugger
date: 2024-11-06 14:00:00 +0100
categories: [Development, Visual Studio]
tags: [visual-studio, debugging, development-tools]
image:
  path: /assets/img/week202446/returnValue.png
  alt: Return value in debugger
---

Visual Studio just added a long-awaited feature to its debugger: **inline return values for return statements**.

![Return value in debugger](/assets/img/week202446/returnValue.png)

Here's why this small change is a big win for devs:

1. **Instant Insight at Return Points**  
   Now, when you step through your code, the debugger will show the values returned by functions directly next to each return statement. No more hunting through watch windows or waiting until the next line to see return values—you'll get them right where they happen.

## Source
For more information, check out the [original announcement on X/Twitter](https://x.com/mkristensen/status/1839677882807017975). 
