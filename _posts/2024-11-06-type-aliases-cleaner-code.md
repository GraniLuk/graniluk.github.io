---
title: Type Aliases - Making Code Clearer with Generics
date: 2024-11-06 19:00:00 +0100
categories: [Development, C#]
tags: [csharp, clean-code, best-practices]
---

When working with generic collections, we often encounter code that's not immediately clear about its purpose. 
For example:

```csharp
// ❌ What does the string means? = new Dictionary<string, string>();
```

The problem here is that we don't know what those strings means, what it represents. This problem is called primitive obsession, more can be read here: [Primitive Obsession](https://refactoring.guru/pl/smells/primitive-obsession)

To solve it we can use aliases:


```csharp
// Create aliases
using UserId = string;
using ProjectId = string;
// Use the type aliases
// ✅ It's clear that the first string is a UserId and the second string is a ProjectId = new Dictionary<UserId, ProjectId>();
```
Alternative option is using records:

```csharp
// Create records
public record UserId(string id);
public record ProjectId(string id);
// Use the type aliases
// ✅ It's clear that the first string is a UserId and the second string is a ProjectId = new Dictionary<UserId, ProjectId>();
```


## Source
For more details about type aliases, check out the [original article by Gérald Barré](https://www.meziantou.net/using-type-aliases-to-make-code-clearer-with-generics.htm).
