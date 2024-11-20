---
title: Organizing Usings with .editorconfig and Static Analysis in .NET
date: 2024-11-24 12:00:00 +0100
categories: [.NET, Code Quality]
tags: [code cleanup, static analysis, .editorconfig, coding standards, .NET]
series: Code Cleanup
image:
  path: /assets/img/week202450/organizeUsings.png
  alt: organize usings
---

# Code Cleanup Series Part 3: Organizing Usings with .editorconfig and Static Analysis in .NET

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

When this option is set, any new file created will automatically include the specified header. For existing files, you can apply the header using Visual Studio's Code Cleanup feature.

#### Applying File Header Preferences

To format existing code and apply the file header preferences, use the Code Cleanup option in Visual Studio:

![Apply file header preferences](path/to/screenshot.png)

For all new classes, the header will be automatically added if set in `.editorconfig`, so you don't need to think about it anymore.

![New header added](path/to/gif.gif)

### Remove Unnecessary Using Directives (IDE0005)

*Draft content for this section will be added later.*

### 'using' Directive Placement (IDE0065)

*Draft content for this section will be added later.*

## Conclusion

By leveraging the `.editorconfig` file and built-in code analyzers in .NET, we can enforce and automate the organization of using directives, ensuring a consistent and clean codebase. Stay tuned for the next post in our **Code Cleanup** series, where we'll delve deeper into more advanced analyzer configurations and best practices.

