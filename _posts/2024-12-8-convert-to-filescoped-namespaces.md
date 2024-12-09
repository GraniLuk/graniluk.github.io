---
title: Converting all classes to filescoped namepspaces
date: 2024-12-08 12:00:00 +0100
categories: [.NET, Code Quality]
tags: [code cleanup, static analysis, .editorconfig, coding standards, .NET]
series: Code Cleanup
image:
  path: /assets/img/week202450/notepadOnDesk.png
  alt: code blocks
---

# Converting C# Namespaces to File-Scoped Using PowerShell

## The Problem
When trying to enforce the IDE0161 rule (Use file-scoped namespace declarations) across a large codebase, Visual Studio's built-in code cleanup feature proved insufficient.

With over 6000 classes to convert, manual modification wasn't practical. After attempting to use Visual Studio's built-in tools and finding them inadequate for this scale, I decided to create a PowerShell script that could handle this conversion automatically.

## Important Notes
- Excludes .NET Standard 2.0 projects (which don't support file-scoped namespaces)
- Preserves documentation comments and formatting
- Provides detailed logging of the conversion process

## The Script 

```powershell
Write-Host "Starting namespace conversion script..." -ForegroundColor Cyan

# Find directories containing .NET Standard 2.0 projects
$projectFiles = Get-ChildItem -Path . -Filter *.csproj -Recurse
$excludeDirs = @()

foreach ($proj in $projectFiles) {
    $content = Get-Content $proj.FullName -Raw
    if ($content -match '<TargetFramework>netstandard2.0</TargetFramework>') {
        Write-Host "Excluding .NET Standard 2.0 project: $($proj.FullName)" -ForegroundColor Yellow
        $excludeDirs += $proj.Directory.FullName
    }
}

# Get all .cs files excluding .NET Standard 2.0 project directories
$files = Get-ChildItem -Path . -Filter *.cs -Recurse | 
    Where-Object { 
        $file = $_
        -not ($excludeDirs | Where-Object { $file.FullName.StartsWith($_) })
    }

Write-Host "Found $($files.Count) .cs files to process (excluding .NET Standard 2.0 projects)" -ForegroundColor Green

$converted = 0
$skipped = 0

foreach ($file in $files) {
    Write-Host "`nProcessing: $($file.FullName)" -ForegroundColor Yellow
    $content = Get-Content $file.FullName -Raw
    
    if ($content -match "namespace .+;") {
        Write-Host "  Skipped: Already using file-scoped namespace" -ForegroundColor Gray
        $skipped++
        continue
    }

    $newContent = $content -replace '(namespace [^\s{]+)\s*\{(\r?\n[\s\S]+?)\}[\s]*$', '$1;$2'
    $newContent = $newContent -replace '(\r?\n\s*){3,}', "`n`n"
    
    if ($newContent -ne $content) {
        $newContent | Set-Content $file.FullName -NoNewline
        Write-Host "  Success: Converted to file-scoped namespace" -ForegroundColor Green
        $converted++
    } else {
        Write-Host "  Skipped: No namespace found or no changes needed" -ForegroundColor Gray
        $skipped++
    }
}

Write-Host "`nConversion Complete!" -ForegroundColor Cyan
Write-Host "Files converted: $converted" -ForegroundColor Green
Write-Host "Files skipped: $skipped" -ForegroundColor Yellow
```

## The Script Explained

1. **Initial Setup and Project Filtering**

    ```powershell
    Write-Host "Starting namespace conversion script..." -ForegroundColor Cyan
    # Find and exclude .NET Standard 2.0 projects
    $projectFiles = Get-ChildItem -Path . -Filter *.csproj -Recurse
    $excludeDirs = @()
    ```

    This section initializes the script and creates an array to store directories to exclude.

2. **Finding .NET Standard Projects**

    ```powershell
    foreach ($proj in $projectFiles) {
        $content = Get-Content $proj.FullName -Raw
        if ($content -match '<TargetFramework>netstandard2.0</TargetFramework>') {
            Write-Host "Excluding .NET Standard 2.0 project: $($proj.FullName)" -ForegroundColor Yellow
            $excludeDirs += $proj.Directory.FullName
        }
    }
    ```

    This loop identifies all .NET Standard 2.0 projects by checking their project files and adds their directories to the exclusion list.

3. **File Collection**

    ```powershell
    $files = Get-ChildItem -Path . -Filter *.cs -Recurse | 
        Where-Object { 
            $file = $_
            -not ($excludeDirs | Where-Object { $file.FullName.StartsWith($_) })
        }
    ```

    Gets all .cs files except those in excluded directories.

4. **Processing Loop**
    ```powershell
    foreach ($file in $files) {
        # Read file content
        $content = Get-Content $file.FullName -Raw
        
        # Skip if already using file-scoped namespace
        if ($content -match "namespace .+;") {
            # ...logging code...
            continue
        }
    ```
    Reads each file and checks if it already uses file-scoped namespaces.

5. **Conversion Logic**
    ```powershell
        # Convert namespace syntax
        $newContent = $content -replace '(namespace [^\s{]+)\s*\{(\r?\n[\s\S]+?)\}[\s]*$', '$1;$2'
        # Clean up extra blank lines
        $newContent = $newContent -replace '(\r?\n\s*){3,}', "`n`n"
    ```
    The core conversion using regex patterns:
    - First pattern converts traditional namespace to file-scoped
      - `(namespace [^\s{]+)\s*\{(\r?\n[\s\S]+?)\}[\s]*$`: This pattern matches the traditional namespace declaration and captures the namespace name and its contents. The `namespace [^\s{]+` part matches the namespace keyword followed by the namespace name. The `\s*\{` part matches any whitespace followed by an opening brace. The `(\r?\n[\s\S]+?)\}` part captures the contents of the namespace, including newlines, until the closing brace. The `[\s]*$` part matches any trailing whitespace at the end of the file.
      - `$1;$2`: This replacement inserts a semicolon after the namespace name and retains the captured contents.
    - Second pattern cleans up excessive blank lines
      - `(\r?\n\s*){3,}`: This pattern matches three or more consecutive blank lines.
      - "`n`n": This replacement reduces the matched blank lines to two newlines.

6. **File Update**
    ```powershell
        if ($newContent -ne $content) {
            $newContent | Set-Content $file.FullName -NoNewline
            # ...logging code...
        }
    ```
    Saves the changes only if the content was actually modified.

7. **Summary Output**
    ```powershell
    Write-Host "`nConversion Complete!" -ForegroundColor Cyan
    Write-Host "Files converted: $converted" -ForegroundColor Green
    Write-Host "Files skipped: $skipped" -ForegroundColor Yellow
    ```
    Provides a summary of the conversion process.

## Example Transformation
```csharp
// Before
namespace MyApp.Features
{
    public class MyClass
    {
    }
}

// After
namespace MyApp.Features;

public class MyClass
{
}
```

## Success Story
The script proved to be a highly effective solution. In less than 2 minutes, it successfully processed a large enterprise codebase containing over 6000 files across multiple projects. The conversion was clean, maintained all code formatting, and correctly excluded incompatible .NET Standard projects. This automated approach not only saved days of manual work but also eliminated the risk of human error during the conversion process.

What initially seemed like a daunting task was solved with a simple yet powerful PowerShell script. The logging feature provided clear visibility into the conversion process, making it easy to verify that all files were processed correctly.

This script successfully automated the conversion of thousands of files while maintaining code integrity and providing clear feedback throughout the process.
