---
title: Understanding the Main Section of .editorconfig
date: 2024-11-10 12:00:00 +0100
categories: [.NET, Code Quality]
tags: [editorconfig, coding-standards, best-practices]
series: Code Cleanup
image:
  path: /assets/img/week202448/arguebetweendevelopers.png
  alt: creative developer
---
# Understanding the Main Section of .editorconfig
As part of our **Code Cleanup** series, let's dive into the core configuration options in `.editorconfig`. Understanding these settings is crucial for maintaining consistent coding standards across your team.

## Basic Configuration Example
```ini
# Remove the line below if you want to inherit .editorconfig settings from higher directories
root = true

# C# files
[*.cs]

#### Core EditorConfig Options ####

# Indentation and spacing
indent_size = 4
indent_style = space
tab_width = 4

# New line preferences
end_of_line = crlf
insert_final_newline = false
```

## Root Setting
The `root` setting determines whether this is the top-most `.editorconfig` file. When set to `true`, EditorConfig stops searching for additional `.editorconfig` files in parent directories. This is useful for ensuring that your project uses its own specific settings without inheriting potentially conflicting rules from parent directories.

## File-Specific Settings
```ini
[*.cs]
```
This section header specifies that all following rules apply only to C# files (files with `.cs` extension). You can have different rules for different file types, allowing for language-specific formatting preferences.

## Core EditorConfig Options

### Indentation Settings
```ini
indent_size = 4
indent_style = space
tab_width = 4
```

#### Indentation Style
- **indent_style**: Chooses between `space` and `tab`
  - Spaces provide consistent rendering across all editors
  - Tabs allow users to customize display width
  - Most C# projects prefer spaces for consistency

#### Indentation Size
- **indent_size**: Sets the number of spaces for each indentation level
- **tab_width**: Specifies the width of tab characters. This setting is not used when using spaces for indentation

### New Line Preferences
```ini
end_of_line = crlf
insert_final_newline = false
```

#### Line Endings
The `end_of_line` setting determines the line ending style:
- **LF** (`\n`): Used on Unix/Linux systems
- **CRLF** (`\r\n`): Standard for Windows
- **CR** (`\r`): Mostly obsolete, used in older Mac systems

#### Final Newline
The `insert_final_newline` setting controls whether files should end with a newline:
- When `true`: Ensures each file ends with a newline character
- When `false`: Files end at the last character of the last line

## How to set it up in Visual Studio?

Visual studio has built-in editor to update settings easily, it opens by default when we open `.editorconfig` file.

![editorConfigBasicSettings](/assets/img/week202448/editorConfigBasicSettings.png)

## How to format code automatically? 

### For one file
- **Format Document:** `Ctrl + K, Ctrl + D`

### For entire solution
1. **Set Format Document section in Code Cleanup profile**
![ProfileSetupWithFormat](/assets/img/week202448/codeCleanUpFormat.png)

2. **Run Code Cleanup on solution**
![RunCodeCleanUpOnSolution](/assets/img/week202448/runCodeCleanUpOnSolution.png)

## How to make sure that new code will be properly formatted?

1. **Enable code cleanup on save**
![RunCodeCleanupOnSave](/assets/img/cleanupOnSave.jpeg)
It will automatically format code on save, so we don't need to worry about it.

2. **Integrate a step in your CI pipeline to run a formatting check**

Just to make sure that everyone follows the rules, we can add a simple check to our CI pipeline:

```yaml
- name: Check code format
  run: dotnet format --verify-no-changes
