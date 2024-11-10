---
title: SonarCloud New Release - Addressing New Warnings in Sonar Way
date: 2024-02-14 15:00:00 +0100
categories: [.NET, Code Quality]
tags: [sonarcloud, code-analysis, static-analysis, quality]
---

SonarSource has released a new version of their .NET analyzer, introducing new warnings to the "Sonar Way" quality profile. This post discusses the new rules and how we addressed them in our projects.

## New Warnings Introduced

### [S127 - "for" loop stop conditions should be invariant](https://sonarsource.github.io/rspec/#/rspec/S127/csharp)

This rule checks that the stop conditions in `for` loops are invariant to prevent unexpected behaviors during iteration. We encountered several instances of this warning but decided to disable most of them due to the complexity of fixing them with minimal benefit.

---

### [S1244 - Floating point numbers should not be tested for equality](https://sonarsource.github.io/rspec/#/rspec/S1244/csharp)

Testing floating-point numbers for equality can lead to unreliable results due to precision errors. In our case, double types were used in NPV (Net Present Value) calculations. We resolved this warning by changing the data types from `double` to `decimal` to improve precision and accuracy.

---

### [S1994 - "for" loop increment clauses should modify the loop's counters](https://sonarsource.github.io/rspec/#/rspec/S1994/csharp)

This rule ensures that the increment clause of a `for` loop actually modifies the loop counter, enhancing code readability and preventing infinite loops. We found several warnings related to this and refactored the affected `for` loops into `while` loops for better clarity.

---

### [S2955 - Generic parameters not constrained to reference types should not be compared to "null"](https://sonarsource.github.io/rspec/#/rspec/S2955/csharp)

Comparing unconstrained generic parameters to `null` can lead to unexpected behaviors since the type might be a value type. We discovered that in our `qTable.CacheGet` method, there was a null check on a generic type `T` without a `class` constraint. After analysis, we updated the method to constrain `T` not only to `class` but specifically to implementations of `qTable`.

---

### [S2629 - Logging templates should be constant](https://sonarsource.github.io/rspec/#/rspec/S2629/csharp)

Constant logging templates ensure that log messages are consistent and easily searchable. We fixed several instances where logging templates were not constant, improving our ability to search and analyze logs effectively.

---

By addressing these new warnings, we improved code quality and maintainability in our projects. It's important to stay up-to-date with the latest tooling updates to ensure continued compliance with best practices.

---

For more details on the release, refer to the [SonarCloud .NET Analyzer Release Notes](https://github.com/SonarSource/sonar-dotnet/releases/tag/9.21.0.86780).