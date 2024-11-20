---
title: Customize AI Git Commit Messages with GitHub Copilot in Visual Studio
date: 2024-11-20 12:00:00 +0100
categories: [.NET, Visual Studio]
tags: [git, commit messages, GitHub Copilot, Visual Studio]
series: Code Cleanup
image:
  path: /assets/img/Visual_Studio_Icon.png
  alt: customize commit message
---

# Customize AI Git Commit Messages with GitHub Copilot in Visual Studio

In this post, we'll explore a new feature in Visual Studio that allows you to customize AI-generated Git commit messages using GitHub Copilot. This feature helps you tailor commit messages to better fit your workflow and team’s standards.

## Customizing Git Commit Messages

With the latest update, you can add additional instructions to the prompt for generating your Git commit message. This customization can include specifying the number of lines, the length of the lines, and providing a sample commit style.

### Configuration Steps

To configure this feature, follow these steps:

1. Go to `Tools > Options > Copilot > Source Control`.
2. In the `Commit message additional instructions:` prompt field, add your custom instructions.

![Configuration Screenshot](/assets/img/week202448/commitMessage.png)

Here's an example configuration:

```plaintext
Choose the type based on changes from this list: 
docs: Documentation-only changes
feat: Introduces a new feature to the codebase
fix: Patches a bug in the codebase
perf: Improves performance
refactor: Code changes that neither fix a bug nor add a feature
revert: Reverts a previous commit
style: Changes that do not affect the meaning of the code (white-space, formatting, etc.)
test: Adds missing tests or corrects existing tests

The first line should contain type and simple summary of changes, with no more than 50 characters.
The second line should be empty. 
Start the full summary on the third line.

Example:

feat: Add user authentication feature

Implement user authentication using JWT tokens:
- Create login and registration endpoints
- Add password hashing and validation
- Integrate JWT token generation and verification
```

It will create messages like this: 

```plaintext
style: Consolidate `foreach` statement and opening brace

The code has been modified to remove the line break between the `foreach` statement and its opening brace. Previously, the `foreach` statement and the opening brace were on separate lines, but now they are combined into a single line. This change improves the readability and consistency of the code.
```

## Benefits of Customizing Commit Messages

By customizing commit messages, you can:

- **Ensure Consistency**: Standardize how commit messages look across your repository.
- **Improve Readability**: Make it easier for team members to understand the purpose of each commit.
- **Enhance Collaboration**: Reduce misunderstandings and improve communication within the team.
