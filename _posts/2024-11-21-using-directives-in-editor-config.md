---
title: Organizing Usings with .editorconfig and Static Analysis in .NET
date: 2024-11-21 12:00:00 +0100
categories: [.NET, Code Quality]
tags: [code cleanup, static analysis, .editorconfig, coding standards, .NET]
series: Code Cleanup
image:
  path: /assets/img/week202450/organizedBooks.png
  alt: organize usings
---

# Code Cleanup Series: Organizing Usings with .editorconfig and Static Analysis in .NET

In this third post of our **Code Cleanup** series, we'll dive into the **Organize Usings** section of `.editorconfig` and explore how to enforce and automate the organization of using directives in .NET projects.

## Rule Index

The **Organize Usings** section contains three rules:
- **Require file header (IDE0073)**
- **Remove unnecessary using directives (IDE0005)**
- **'using' directive placement (IDE0065)**

### Require File Header (IDE0073)

The `IDE0073` rule ensures that each file contains a specified header. This is particularly useful for adding licensing information or other standard comments to the top of your files.

#### Options

Specify the required header text by setting the `file_header_template` option.

- **Non-empty string**: Requires the specified file header.
- **Unset or empty string**: Does not require a file header.

#### Example

Here is an example of how to set the `file_header_template` in your `.editorconfig`:

```properties
# .editorconfig
[*.cs]
file_header_template = Copyright (c) SomeCorp. All rights reserved.\nLicensed under the xyz license.
```

When this option is set, any new file created will automatically include the specified header.

#### How to refactor existing code?

1. **Set Apply File Header Preferences section in Code Cleanup profile**
![Apply file header preferences](/assets/img/week202450/ApplyFileHeaderPreferences.png)

2. **[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**


#### How to make sure that new code will be properly formatted?

For all new classes, the header will be automatically added if set in `.editorconfig`, so you don't need to think about it anymore.

```cs
// Copyright (c) SomeCorp. All rights reserved.
// Licensed under the xyz license.:error

namespace EditorConfixExamples
{
    internal class FileName
    {
    }
}
```

### Remove Unnecessary Using Directives (IDE0005)

The `IDE0005` rule ensures that any unnecessary using directives are removed from your code. This helps keep your code clean and free of unused references, improving readability and reducing potential confusion.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_diagnostic.IDE0005.severity = warning
```

#### How to refactor existing code?

1. **Set Remove unnecessary imports or usings section in Code Cleanup profile**
![Remove unnecessary imports or usings](/assets/img/week202450/RemoveUnecessaryUsings.png)

2. **[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

#### How to make sure that new code will be properly formatted?

By configuring Code Cleanup to run on save with a profile that includes the "Remove unnecessary imports or usings" option, we can prevent the accumulation of superfluous using directives. This approach streamlines your code without requiring manual intervention each time you save your work.

![Run Code Cleanup profile on Save](/assets/img/cleanupOnSave.jpeg))

To ensure that no new unnecessary using directives are added to the repository, set the severity of this rule to warning and add a policy to your CI/CD pipeline to disallow new warnings in the code.

### 'using' Directive Placement (IDE0065)

The `IDE0065` rule ensures that using directives are consistently placed according to your team's preferences. This helps maintain a consistent structure and improves readability.

#### Example in .editorconfig

To enforce this rule, add the following configuration to your `.editorconfig` file:

```properties
# .editorconfig
[*.cs]
dotnet_diagnostic.IDE0065.severity = warning
```

#### Options for 'using' Directive Placement (IDE0065)

The `IDE0065` rule has two possible options for the placement of using directives: `outside_namespace` and `inside_namespace`.

##### outside_namespace

When using directives are placed outside the namespace, they appear at the top of the file, before the namespace declaration.

Example:

```csharp
// .editorconfig
[*.cs]
dotnet_style_using_directive_placement = outside_namespace

// Example.cs
using System;
using System.Collections.Generic;

namespace ExampleNamespace
{
    public class ExampleClass
    {
        // Class implementation
    }
}
```

##### inside_namespace

When using directives are placed inside the namespace, they appear within the namespace declaration.

Example:

```csharp
// .editorconfig
[*.cs]
dotnet_style_using_directive_placement = inside_namespace

// Example.cs
namespace ExampleNamespace
{
    using System;
    using System.Collections.Generic;

    public class ExampleClass
    {
        // Class implementation
    }
}
```

#### How to refactor existing code?

To correct the placement of existing using directives, you can use Visual Studio's Code Cleanup feature with the option "Place 'using' directives inside/outside namespace":

1. **Set Remove unnecessary imports or usings section in Code Cleanup profile**
![Remove unnecessary imports or usings](/assets/img/week202450/ApplyUsingDirectivePlacementPreferences.png)

2. **[Run Code Cleanup On Solution](/assets/img/week202448/runCodeCleanUpOnSolution.png)**

#### How to make sure that new code will be properly formatted?

To ensure that no new misplaced using directives are added to the repository, set the severity of this rule to warning and add a policy to your CI/CD pipeline to disallow new warnings in the code.

## Conclusion

By leveraging the `.editorconfig` file and built-in code analyzers in .NET, we can enforce and automate the organization of using directives, ensuring a consistent and clean codebase. Stay tuned for the next post in our **Code Cleanup** series, where we'll delve deeper into more advanced analyzer configurations and best practices.


