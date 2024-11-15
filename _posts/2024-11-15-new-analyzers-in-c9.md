---
title: "Exploring New Code Analyzers in .NET 9: Automatic Refactoring for Better Code"
date: 2024-11-15 12:00:00 +0100
categories: [.NET, Code Quality]
tags: [editorconfig, roslyn, code-analysis, code-quality]
image:
  path: /assets/img/week202448/broom.png
  alt: Cleaning up
---

# Exploring New Code Analyzers in .NET 9: Automatic Refactoring for Better Code

Code analyzers are powerful tools in the .NET ecosystem that help developers write cleaner, more efficient, and more maintainable code. These analyzers work behind the scenes, constantly evaluating your code and suggesting improvements. As a huge fan of automatic code refactoring, I'm always excited to see new analyzers introduced. After all, if we can get code improvements for free without extra effort, why not take advantage of it? With the release of .NET 9, we've got a fresh set of analyzers to explore and implement in our projects.

Let's dive into some of the new analyzers introduced in .NET 9 and see how they can help us write better code.

## CA1514: Avoid Redundant Length Argument

★★★★☆ (4/5 stars)

This analyzer helps improve code readability by identifying and removing unnecessary length arguments when slicing strings or spans.

### Example of violation:

```csharp
string fullName = "John Doe";
string lastName = fullName.Substring(5, fullName.Length - 5); // Violation
```

### Corrected code:

```csharp
string fullName = "John Doe";
string lastName = fullName.Substring(5); // Correct
```

This rule simplifies our code and reduces the chance of errors in manual length calculations.

## CA1515: Consider making public types internal

★★★★☆ (4/5 stars)

This analyzer suggests reviewing your code to determine if public types (classes, structs, etc.) should be restricted to internal access instead.

### Example of violation:

```csharp
public class Program
{
    public static void Main(string[] args)
    {
        // Method implementation
    }
}
```

### Corrected code:

```csharp
internal class Program
{
    public static void Main(string[] args)
    {
        // Method implementation
    }
}
```

By making types `internal` instead of `public`, you limit their accessibility to within the same assembly, which:

* Reduces the public API surface of your code.
* Makes future maintenance easier, as fewer types are exposed for use by external assemblies.
* Helps prevent accidental usage by external code, preserving encapsulation and flexibility to modify internal implementations without breaking changes.

## CA1871: Do not pass a nullable struct to 'ArgumentNullException.ThrowIfNull'

★★☆☆☆ (2/5 stars)

This analyzer identifies performance issues when passing nullable structs to `ArgumentNullException.ThrowIfNull`, which causes boxing and a performance penalty.

### Example of violation:

```csharp
static void Print(int? value)
{
    ArgumentNullException.ThrowIfNull(value); // Violation
    Console.WriteLine(value.Value);
}
```

### Corrected code:

```csharp
static void Print(int? value)
{
    if (!value.HasValue)
    {
        throw new ArgumentNullException(nameof(value));
    }
    Console.WriteLine(value.Value);
}
```

This rule improves performance by avoiding unnecessary boxing of nullable structs.

## CA1872: Prefer 'Convert.ToHexString' and 'Convert.ToHexStringLower' over call chains based on 'BitConverter.ToString'

★★☆☆☆ (2/5 stars)

This analyzer suggests using `Convert.ToHexString` or `Convert.ToHexStringLower` instead of call chains based on `BitConverter.ToString` for better performance when encoding bytes to a hexadecimal string representation.

### Example of violation:

```csharp
byte[] data = Encoding.ASCII.GetBytes("Hello World");
string hexString = BitConverter.ToString(data).Replace("-", ""); // Violation
string lowerHexString = BitConverter.ToString(data).Replace("-", "").ToLower(); // Violation
```

### Corrected code:

```csharp
byte[] data = Encoding.ASCII.GetBytes("Hello World");
string hexString = Convert.ToHexString(data); // Correct
string lowerHexString = Convert.ToHexStringLower(data); // Correct
```

This rule improves performance by using more efficient and allocation-friendly methods for converting bytes to hexadecimal strings. The `Convert.ToHexString` and `Convert.ToHexStringLower` methods are optimized for this specific task and avoid unnecessary string manipulations.

## CA2022: Avoid inexact read with Stream.Read

★★★★★ (5/5 stars)

This analyzer warns about potential reliability issues when using `Stream.Read` or `Stream.ReadAsync` without checking the return value, which might lead to incomplete data reads.

### Example of violation:

```csharp
void ReadData(Stream stream, byte[] buffer)
{
    stream.Read(buffer, 0, buffer.Length); // Violation
}
```

### Corrected code:

```csharp
void ReadData(Stream stream, byte[] buffer)
{
    stream.ReadExactly(buffer); // Correct
}
```

This rule is crucial for ensuring reliable stream reading operations. `Stream.Read` and `Stream.ReadAsync` might return fewer bytes than requested, which can lead to unreliable code if the return value isn't checked. Fortunately .NET 8 introduced `ReadAtLeast()` and `ReadExactly()` which calls `Read()` in a loop for you. Using `Stream.ReadExactly` or `Stream.ReadExactlyAsync` ensures that the exact number of bytes requested are read or an exception is thrown. 

The analyzer helps prevent subtle bugs that can occur when not all requested bytes are read from a stream. This is particularly important in scenarios involving network communications or file I/O where partial reads can lead to data corruption or unexpected behavior.

### Sources:
1. https://www.reddit.com/r/csharp/comments/1cf5atr

## CA2262: Set 'MaxResponseHeadersLength' properly

★★★☆☆ (3/5 stars)

This analyzer warns about potential misconfigurations when setting the `MaxResponseHeadersLength` property, which is measured in kilobytes, not in bytes.

### Example of violation:

```csharp
var listener = new HttpListener();
listener.MaxResponseHeadersLength = 8192; // Violation: This sets it to 8MB, not 8KB
```

### Corrected code:

```csharp
var listener = new HttpListener();
listener.MaxResponseHeadersLength = 8; // Correct: This sets it to 8KB
```

This rule is important for preventing unintended configurations that could lead to excessive memory usage or potential denial-of-service vulnerabilities. The `MaxResponseHeadersLength` property is measured in kilobytes, so setting it to large values thinking they're in bytes can result in allocating much more memory than intended.

By following this rule, developers can ensure that their HTTP listeners are configured correctly, balancing between allowing sufficient header space and preventing excessive resource allocation.

## CA2263: Prefer generic overload when type is known

★★★★★ (5/5 stars)

This analyzer suggests using generic overloads instead of method overloads that accept a `System.Type` argument when the type is known at compile time.

### Example of violation:

Consider using a method like `System.Collections.ArrayList.Add` versus using a generic `List<T>.Add<T>`:

```csharp
// Non-generic version
ArrayList arrayList = new ArrayList();
arrayList.Add(42); // CA2263 suggests using a generic collection

// Generic version (preferred)
List<int> genericList = new List<int>();
genericList.Add(42); // Complies with CA2263
```

Another example could involve calling a method that retrieves an object, where a generic version is available:

```csharp
// Non-generic method call
object obj = someService.GetService(typeof(MyType));

// CA2263 will suggest using:
MyType instance = someService.GetService<MyType>(); // Prefer this for type safety
```

This rule promotes cleaner and more type-safe code with improved compile-time checks. Generic overloads are preferable when the type is known at compile time because they provide better type safety and can lead to more efficient code.

By following this rule, developers can write more robust code that leverages the C# type system more effectively. It also helps in catching potential type-related errors at compile-time rather than runtime, leading to more reliable applications.

## CA2264: Do not pass a non-nullable value to 'ArgumentNullException.ThrowIfNull'

★★★★☆ (4/5 stars)

This analyzer warns against passing non-nullable value types to `ArgumentNullException.ThrowIfNull`, as it can lead to unnecessary allocations and potential runtime exceptions.

### Example of violation:

```csharp
public void ProcessValue(int value)
{
    ArgumentNullException.ThrowIfNull(value); // Violation
    // Method implementation
}
```

### Corrected code:

```csharp
public void ProcessValue(int value)
{
    // No need for null check on non-nullable value types
    // Method implementation
}
```

This rule is important for preventing unnecessary overhead and potential runtime issues. `ArgumentNullException.ThrowIfNull` is designed to check for null references, but non-nullable value types (like `int`, `bool`, `struct`, etc.) can never be null. Using this method with non-nullable types can lead to:

1. Unnecessary allocations and performance overhead.
2. Potential runtime exceptions if the method's implementation changes in future framework versions.

By adhering to this rule, developers can write more efficient and correct code, avoiding redundant null checks on types that can't be null. It also helps in maintaining cleaner code by eliminating unnecessary guard clauses.

In cases where you want to validate that a value type is not its default value, consider using `ArgumentOutOfRangeException` or a custom validation method instead.

## CA2265: Do not compare Span<T> to null or default

★★★★☆ (4/5 stars)

This analyzer warns against comparing a `Span<T>` instance to `null` or `default`, as it might not behave as intended.

### Example of violation:

```csharp
Span<int> span = new([1, 2, 3]);

if (span == null) { } // Violation
if (span == default) { } // Violation
```

### Corrected code:

```csharp
Span<int> span = new([1, 2, 3]);

if (span.IsEmpty) { } // Correct
```

This rule is important because comparing a `Span<T>` to `null` or `default` can lead to unexpected behavior. In C#, `default` and the `null` literal are implicitly converted to `Span<T>.Empty`. This means that such comparisons will not actually check for null or uninitialized spans, but rather for empty spans.

Key points to remember:

1. `Span<T>` is a value type and can never be null.
2. Comparing `Span<T>` to `null` or `default` actually checks if the span is empty.
3. Use the `IsEmpty` property to explicitly check if a span contains no elements.

By following this rule, developers can write more accurate and intention-revealing code when working with `Span<T>`. It helps prevent subtle bugs that could arise from misunderstanding how `Span<T>` comparisons work.

## Conclusion

The introduction of these new analyzers in .NET 9 is a testament to the continuous improvement of the platform. As someone who's been testing .NET 9 extensively and discovering new features, I'm thrilled to see these additions to the code analysis toolkit. These analyzers not only help us write better code but also serve as learning tools, guiding developers towards best practices in C# programming.

By leveraging these automatic refactoring suggestions, we can significantly improve our code quality with minimal effort. It's exciting to see how .NET 9 is pushing the boundaries of what's possible in terms of code analysis and optimization. As we continue to explore and implement these new features, I'm confident that our codebases will become more robust, efficient, and maintainable.

Have you started using .NET 9 yet? What's your favorite new feature or analyzer? Let me know in the comments below!
