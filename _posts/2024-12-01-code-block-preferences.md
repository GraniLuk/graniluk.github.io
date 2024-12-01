---
title: Code-Block Preferences with .editorconfig and Static Analysis in .NET
date: 2024-11-28 12:00:00 +0100
categories: [.NET, Code Quality]
tags: [code cleanup, static analysis, .editorconfig, coding standards, .NET]
series: Code Cleanup
image:
  path: /assets/img/week202450/organizedBooks.png
  alt: code blocks
---

# Code Cleanup Series: Code-Block Preferences with .editorconfig and Static Analysis in .NET

In this post of our **Code Cleanup** series, we'll explore the **Code-Block Preferences** section of `.editorconfig` and how to enforce and automate these preferences in .NET projects.

## Rule Index

The **Code-Block Preferences** section contains several rules:
- **Add braces (IDE0011)**
- **Use simple 'using' statement (IDE0063)**
- **Namespace declaration preferences (IDE0160, IDE0161)**
- **Remove unnecessary lambda expression (IDE0200)**
- **Convert to top-level statements (IDE0210)**
- **Convert to 'Program.Main' style program (IDE0211)**
- **Use primary constructor (IDE0290)**
- **Prefer 'System.Threading.Lock' (IDE0330)**

### Add Braces (IDE0011)

The `IDE0011` rule ensures that braces are added to all control blocks, even if they contain a single statement. This improves readability and reduces the risk of errors when modifying the code.

#### Options

The `IDE0011` rule has three possible options: `true`, `false`, and `when_multiline`.

- **true**: Always add braces to control blocks.
- **false**: Do not add braces to control blocks.
- **when_multiline**: Add braces only when the control block spans multiple lines.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_style_require_braces = true
dotnet_diagnostic.IDE0011.severity = warning
```

#### Code Examples

**true**: Always add braces

```csharp
if (condition)
{
    DoSomething();
}
```

**false**: Do not add braces

```csharp
if (condition)
    DoSomething();
```

**when_multiline**: Add braces only when the control block spans multiple lines

```csharp
// Single line, no braces
if (condition)
    DoSomething();

// Multiple lines, add braces
if (condition)
{
    DoSomething();
    DoSomethingElse();
}
```

#### How to Refactor Existing Code?

To refactor existing code and add braces where necessary, you can use Visual Studio's Code Cleanup feature:

1. Open Visual Studio.
2. Go to `Edit` > `Advanced` > `Format Document`.
3. Alternatively, you can use the Code Cleanup feature:
   - Click on the broom icon at the bottom of the editor.
   - Select the profile that includes "Add braces".

<!-- ![Add braces](path/to/screenshot.png) -->

#### How to Make Sure That New Code Will Be Properly Formatted?

To ensure that new code is properly formatted with the required braces, configure Visual Studio to run Code Cleanup on save:

1. Go to `Tools` > `Options`.
2. Navigate to `Text Editor` > `C#` > `Code Style` > `Code Cleanup`.
3. Check the option "Run Code Cleanup profile on Save".
4. Ensure your Code Cleanup profile includes the "Add braces" option.

**[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

### Use Simple 'using' Statement (IDE0063)

The `IDE0063` rule enforces the use of the simplified `using` statement introduced in C# 8.0. This reduces the scope of the `using` declaration and improves readability.

#### Options

The `IDE0063` rule has two possible options: `true` and `false`.

- **true**: Use the simplified `using` statement.
- **false**: Use the traditional `using` statement.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_style_prefer_simple_using_statement = true
dotnet_diagnostic.IDE0063.severity = warning
```

#### Code Examples

**true**: Use the simplified `using` statement

```csharp
// Simplified using statement
using var stream = new FileStream("path/to/file", FileMode.Open);
```

**false**: Use the traditional `using` statement

```csharp
// Traditional using statement
using (var stream = new FileStream("path/to/file", FileMode.Open))
{
    // Use the stream
}
```

#### How to Refactor Existing Code?

To refactor existing code and apply the simplified `using` statement where necessary, you can use Visual Studio's Code Cleanup feature:

1. Open Visual Studio.
2. Go to `Edit` > `Advanced` > `Format Document`.
3. Alternatively, you can use the Code Cleanup feature:
   - Click on the broom icon at the bottom of the editor.
   - Select the profile that includes "Use simple 'using' statement".

<!-- ![Use simple 'using' statement](path/to/screenshot.png) -->

#### How to Make Sure That New Code Will Be Properly Formatted?

To ensure that new code is properly formatted with the simplified `using` statement, configure Visual Studio to run Code Cleanup on save:

1. Go to `Tools` > `Options`.
2. Navigate to `Text Editor` > `C#` > `Code Style` > `Code Cleanup`.
3. Check the option "Run Code Cleanup profile on Save".
4. Ensure your Code Cleanup profile includes the "Use simple 'using' statement" option.

**[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

### Namespace Declaration Preferences (IDE0160, IDE0161)

The `IDE0160` and `IDE0161` rules enforce the preferred style for namespace declarations, either block-scoped or file-scoped. This helps maintain a consistent structure and improves readability.

#### Options

The namespace declaration preferences have two possible options: `block_scoped` and `file_scoped`.

- **block_scoped**: Use block-scoped namespace declarations.
- **file_scoped**: Use file-scoped namespace declarations.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_style_namespace_declarations = block_scoped
dotnet_diagnostic.IDE0160.severity = warning
dotnet_diagnostic.IDE0161.severity = warning
```

#### Code Examples

**block_scoped**: Use block-scoped namespace declarations

```csharp
namespace ExampleNamespace
{
    public class ExampleClass
    {
        // Class implementation
    }
}
```

**file_scoped**: Use file-scoped namespace declarations

```csharp
namespace ExampleNamespace;

public class ExampleClass
{
    // Class implementation
}
```

#### How to Refactor Existing Code?

To refactor existing code and apply the preferred namespace declaration style, you can use Visual Studio's Code Cleanup feature:

1. Open Visual Studio.
2. Go to `Edit` > `Advanced` > `Format Document`.
3. Alternatively, you can use the Code Cleanup feature:
   - Click on the broom icon at the bottom of the editor.
   - Select the profile that includes "Namespace declaration preferences".

<!-- ![Namespace declaration preferences](path/to/screenshot.png) -->

#### How to Make Sure That New Code Will Be Properly Formatted?

To ensure that new code is properly formatted with the preferred namespace declaration style, configure Visual Studio to run Code Cleanup on save:

1. Go to `Tools` > `Options`.
2. Navigate to `Text Editor` > `C#` > `Code Style` > `Code Cleanup`.
3. Check the option "Run Code Cleanup profile on Save".
4. Ensure your Code Cleanup profile includes the "Namespace declaration preferences" option.

**[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

### Remove Unnecessary Lambda Expression (IDE0200)

The `IDE0200` rule removes unnecessary lambda expressions, simplifying the code and improving readability.

#### Options

The `IDE0200` rule has two possible options: `true` and `false`.

- **true**: Remove unnecessary lambda expressions.
- **false**: Do not remove unnecessary lambda expressions.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_style_prefer_simplified_lambda_expressions = true
dotnet_diagnostic.IDE0200.severity = warning
```

#### Code Examples

**true**: Remove unnecessary lambda expressions

```csharp
// Simplified lambda expression
Func<int, int> square = x => x * x;
```

**false**: Do not remove unnecessary lambda expressions

```csharp
// Unnecessary lambda expression
Func<int, int> square = (int x) => { return x * x; };
```

#### How to Refactor Existing Code?

To refactor existing code and remove unnecessary lambda expressions, you can use Visual Studio's Code Cleanup feature:

1. Open Visual Studio.
2. Go to `Edit` > `Advanced` > `Format Document`.
3. Alternatively, you can use the Code Cleanup feature:
   - Click on the broom icon at the bottom of the editor.
   - Select the profile that includes "Remove unnecessary lambda expression".

<!-- ![Remove unnecessary lambda expression](path/to/screenshot.png) -->

#### How to Make Sure That New Code Will Be Properly Formatted?

To ensure that new code is properly formatted without unnecessary lambda expressions, configure Visual Studio to run Code Cleanup on save:

1. Go to `Tools` > `Options`.
2. Navigate to `Text Editor` > `C#` > `Code Style` > `Code Cleanup`.
3. Check the option "Run Code Cleanup profile on Save".
4. Ensure your Code Cleanup profile includes the "Remove unnecessary lambda expression" option.

**[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

### Convert to Top-Level Statements (IDE0210)

The `IDE0210` rule converts traditional `Main` methods to top-level statements, simplifying the entry point of the application.

#### Options

The `IDE0210` rule has two possible options: `true` and `false`.

- **true**: Convert to top-level statements.
- **false**: Do not convert to top-level statements.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_style_prefer_top_level_statements = true
dotnet_diagnostic.IDE0210.severity = warning
```

#### Code Examples

**true**: Convert to top-level statements

```csharp
// Top-level statements
using System;

Console.WriteLine("Hello, World!");
```

**false**: Do not convert to top-level statements

```csharp
// Traditional Main method
using System;

namespace ExampleNamespace
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, World!");
        }
    }
}
```

#### How to Refactor Existing Code?

To refactor existing code and convert traditional `Main` methods to top-level statements, you can use Visual Studio's Code Cleanup feature:

1. Open Visual Studio.
2. Go to `Edit` > `Advanced` > `Format Document`.
3. Alternatively, you can use the Code Cleanup feature:
   - Click on the broom icon at the bottom of the editor.
   - Select the profile that includes "Convert to top-level statements".

<!-- ![Convert to top-level statements](path/to/screenshot.png) -->

#### How to Make Sure That New Code Will Be Properly Formatted?

To ensure that new code is properly formatted with top-level statements, configure Visual Studio to run Code Cleanup on save:

1. Go to `Tools` > `Options`.
2. Navigate to `Text Editor` > `C#` > `Code Style` > `Code Cleanup`.
3. Check the option "Run Code Cleanup profile on Save".
4. Ensure your Code Cleanup profile includes the "Convert to top-level statements" option.

**[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

### Convert to 'Program.Main' Style Program (IDE0211)

The `IDE0211` rule converts top-level statements back to the traditional `Program.Main` style, if preferred.

#### Options

The `IDE0211` rule has two possible options: `true` and `false`.

- **true**: Convert to 'Program.Main' style program.
- **false**: Do not convert to 'Program.Main' style program.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_style_prefer_program_main_style = true
dotnet_diagnostic.IDE0211.severity = warning
```

#### Code Examples

**true**: Convert to 'Program.Main' style program

```csharp
// Traditional Main method
using System;

namespace ExampleNamespace
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, World!");
        }
    }
}
```

**false**: Do not convert to 'Program.Main' style program

```csharp
// Top-level statements
using System;

Console.WriteLine("Hello, World!");
```

#### How to Refactor Existing Code?

To refactor existing code and convert top-level statements back to the traditional `Program.Main` style, you can use Visual Studio's Code Cleanup feature:

1. Open Visual Studio.
2. Go to `Edit` > `Advanced` > `Format Document`.
3. Alternatively, you can use the Code Cleanup feature:
   - Click on the broom icon at the bottom of the editor.
   - Select the profile that includes "Convert to 'Program.Main' style program".

<!-- ![Convert to 'Program.Main' style program](path/to/screenshot.png) -->

#### How to Make Sure That New Code Will Be Properly Formatted?

To ensure that new code is properly formatted with the 'Program.Main' style, configure Visual Studio to run Code Cleanup on save:

1. Go to `Tools` > `Options`.
2. Navigate to `Text Editor` > `C#` > `Code Style` > `Code Cleanup`.
3. Check the option "Run Code Cleanup profile on Save".
4. Ensure your Code Cleanup profile includes the "Convert to 'Program.Main' style program" option.

**[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

### Use Primary Constructor (IDE0290)

The `IDE0290` rule enforces the use of primary constructors, simplifying class definitions and improving readability.

#### Options

The `IDE0290` rule has two possible options: `true` and `false`.

- **true**: Use primary constructors.
- **false**: Do not use primary constructors.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_style_prefer_primary_constructors = true
dotnet_diagnostic.IDE0290.severity = warning
```

#### Code Examples

**true**: Use primary constructors

```csharp
// Primary constructor
public class Person(string name, int age)
{
    public string Name { get; } = name;
    public int Age { get; } = age;
}
```

**false**: Do not use primary constructors

```csharp
// Traditional constructor
public class Person
{
    public string Name { get; }
    public int Age { get; }

    public Person(string name, int age)
    {
        Name = name;
        Age = age;
    }
}
```

#### How to Refactor Existing Code?

To refactor existing code and convert traditional constructors to primary constructors, you can use Visual Studio's Code Cleanup feature:

1. Open Visual Studio.
2. Go to `Edit` > `Advanced` > `Format Document`.
3. Alternatively, you can use the Code Cleanup feature:
   - Click on the broom icon at the bottom of the editor.
   - Select the profile that includes "Use primary constructor".

<!-- ![Use primary constructor](path/to/screenshot.png) -->

#### How to Make Sure That New Code Will Be Properly Formatted?

To ensure that new code is properly formatted with primary constructors, configure Visual Studio to run Code Cleanup on save:

1. Go to `Tools` > `Options`.
2. Navigate to `Text Editor` > `C#` > `Code Style` > `Code Cleanup`.
3. Check the option "Run Code Cleanup profile on Save".
4. Ensure your Code Cleanup profile includes the "Use primary constructor" option.

**[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

Sure, here is the updated draft with a detailed description for "Prefer 'System.Threading.Lock' (IDE0330)" and the additional sections:

```markdown
### Prefer 'System.Threading.Lock' (IDE0330)

The `IDE0330` rule enforces the use of `System.Threading.Lock` for thread synchronization, improving code consistency and reliability.

#### Options

The `IDE0330` rule has two possible options: `true` and `false`.

- **true**: Prefer `System.Threading.Lock`.
- **false**: Do not prefer `System.Threading.Lock`.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_style_prefer_system_threading_lock = true
dotnet_diagnostic.IDE0330.severity = warning
```

#### Code Examples

**true**: Prefer `System.Threading.Lock`

```csharp
// Using System.Threading.Lock
using System.Threading;

public class Example
{
    private readonly Lock _lock = new Lock();

    public void DoSomething()
    {
        using (_lock.Acquire())
        {
            // Critical section
        }
    }
}
```

**false**: Do not prefer `System.Threading.Lock`

```csharp
// Using traditional lock statement
public class Example
{
    private readonly object _lock = new object();

    public void DoSomething()
    {
        lock (_lock)
        {
            // Critical section
        }
    }
}
```

#### How to Refactor Existing Code?

To refactor existing code and convert traditional lock statements to `System.Threading.Lock`, you can use Visual Studio's Code Cleanup feature:

1. Open Visual Studio.
2. Go to `Edit` > `Advanced` > `Format Document`.
3. Alternatively, you can use the Code Cleanup feature:
   - Click on the broom icon at the bottom of the editor.
   - Select the profile that includes "Prefer 'System.Threading.Lock'".

<!-- ![Prefer 'System.Threading.Lock'](path/to/screenshot.png) -->

#### How to Make Sure That New Code Will Be Properly Formatted?

To ensure that new code is properly formatted with `System.Threading.Lock`, configure Visual Studio to run Code Cleanup on save:

1. Go to `Tools` > `Options`.
2. Navigate to `Text Editor` > `C#` > `Code Style` > `Code Cleanup`.
3. Check the option "Run Code Cleanup profile on Save".
4. Ensure your Code Cleanup profile includes the "Prefer 'System.Threading.Lock'" option.

**[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

## Conclusion
In this post, we explored various code-block preferences that can be enforced using `.editorconfig` and static analysis in .NET. By configuring those rules, you can maintain a clean and consistent codebase. Utilizing Visual Studio's Code Cleanup feature and configuring it to run on save ensures that both existing and new code adhere to these standards, improving overall code quality and maintainability.