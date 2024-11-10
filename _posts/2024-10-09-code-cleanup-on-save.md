---
title: Code Cleanup on Save in Visual Studio 2022
date: 2024-10-09 10:00:00 +0100
categories: [.NET, Visual Studio]
tags: [visual-studio, productivity, code-cleanup]
image:
  path: /assets/img/cleanupOnSave.jpeg
  alt: Code Cleanup on Save feature in Visual Studio 2022
---

Visual Studio 2022 has introduced a game-changing feature: Code Cleanup on Save. This feature is particularly valuable for teams dealing with build failures caused by unnecessary using statements.

## The Problem It Solves

Previously, developers would face frustrating scenarios where builds would fail due to unnecessary usings, resulting in:
- 10-minute wait times for initial build failure
- Additional time spent removing usings
- 30-minute delays in getting test results

## How to Enable

1. **Access Settings**  
   Open Visual Studio Settings and navigate to the Code Cleanup section.

2. **Configure Auto-Save**  
   Enable the "Run Code Cleanup on Save" option.

3. **Select Cleanup Actions**  
   In the code cleanup configuration, ensure "Remove unnecessary imports or usings" is selected.

![Code cleanup on save option](/assets/img/cleanupOnSave.jpeg)

## Benefits

- **Automatic Cleanup:** No more manual removal of unnecessary usings
- **Faster Build Times:** Prevent build failures due to code style issues
- **Improved Productivity:** Immediate feedback and fixes while coding

## Source
For more details, check out the [official Visual Studio blog post](https://devblogs.microsoft.com/visualstudio/bringing-code-cleanup-on-save-to-visual-studio-2022-17-1-preview-2/).