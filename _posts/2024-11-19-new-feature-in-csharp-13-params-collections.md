---
title: "New Feature in C# 13: Params Collections"
date: 2024-11-19 12:00:00 +0100
categories: [.NET, C#]
tags: [csharp, params, collections, NET9]
image:
  path: /assets/img/Visual_Studio_Icon.png
  alt: Params Collections in C#
---

# New Feature in C# 13: Params Collections

C# 13 introduces a significant enhancement to the `params` keyword with the new "params collections" feature. This new functionality provides developers with more flexibility and potential performance improvements when working with methods that accept a variable number of arguments.

## Overview of params collections

The `params` keyword in C# 13 is no longer limited to arrays. It can now be used with a variety of collection types, including `Span<T>`, `ReadOnlySpan<T>`, and any collection type that implements the `IEnumerable` interface and has an `Add` method.

## Key Benefits

1. **Performance Improvements**: Using `params` with types like `Span<T>` can lead to better performance by reducing heap allocations.
2. **Flexibility**: Developers can now use `params` with various collection types, not just arrays.
3. **Backward Compatibility**: Existing code using `params` with arrays will continue to work.

## Syntax and Usage

The basic syntax remains similar to the previous `params` usage, but now allows for different collection types:

```csharp
public void Concat<T>(params ReadOnlySpan<T> items)
{
    // Method implementation
}
```

### Example

```cs
public class StringConcatenator
{
    public string Concat<T>(params ReadOnlySpan<T> items)
    {
        return string.Join("", items.ToArray());
    }
}

// Usage examples
var concatenator = new StringConcatenator();

// Using individual arguments
string result1 = concatenator.Concat("Hello", " ", "World");
Console.WriteLine(result1); // Output: Hello World

// Using an array
string[] words = { "C#", "13", "is", "awesome" };
string result2 = concatenator.Concat(words);
Console.WriteLine(result2); // Output: C#13isawesome

// Using a collection expression
string result3 = concatenator.Concat(["Params", " ", "collections", " ", "rock!"]);
Console.WriteLine(result3); // Output: Params collections rock!

// Using a mix of types
string result4 = concatenator.Concat("Mix", " ", "of", " ", 123, " ", true);
Console.WriteLine(result4); // Output: Mix of 123 True
```

## Supported Collection Types

- `Arrays` (as before)
- `Span<T>`
- `ReadOnlySpan<T>`
- `IEnumerable<T>`
- `IReadOnlyCollection<T>`
- `IReadOnlyList<T>`
- `ICollection<T>`
- `IList<T>`

## Performance Considerations

When using `params Span<T>` or `params ReadOnlySpan<T>`, the compiler can often optimize the code to use stack space instead of heap allocations, leading to better performance.

## Overload Resolution

When multiple overloads of a method exist with different `params` collection types, the compiler will attempt to choose the most appropriate overload based on the arguments provided.

The compiler generally prefers the Span<T> or ReadOnlySpan<T> overloads when possible, as these types offer better performance by avoiding heap allocations. However, when dealing with more complex scenarios or types that don't have a direct conversion to spans, the IEnumerable<T> overload is used.

### Examples

```csharp
// Using with ReadOnlySpan<T>
public static void WriteNumbers<T>(params ReadOnlySpan<T> values) 
    => Console.WriteLine("Span");

// Using with IEnumerable<T>
public static void WriteNumbers<T>(params IEnumerable<T> values) 
    => Console.WriteLine("IEnumerable");

// Usage
WriteNumbers(1, 2, 3);  // Calls the Span version
WriteNumbers([1, 2, 3]);  // Calls the Span version
WriteNumbers(new[] { 1, 2, 3 });  // Calls the Span version
WriteNumbers(ints.Where(x => x < 4));  // Calls the IEnumerable version

```

## Limitations and Considerations

- The `params` keyword still must be used on the last parameter of a method.
- When using interfaces like `IEnumerable<T>`, the compiler synthesizes the storage for the arguments.
- Care should be taken when overloading methods with different `params` collection types to avoid ambiguity.

## Availability

This feature is part of C# 13 and is available in the latest Visual Studio 2022 version or the .NET 9 SDK.

In conclusion, the `params collections` feature in C# 13 provides developers with more flexibility and potential performance improvements when working with methods that accept a variable number of arguments. It's a significant enhancement that aligns well with modern C# programming practices and the performance-focused direction of the language.

Have you tried this new feature in C# 13? Let me know your thoughts in the comments below!
