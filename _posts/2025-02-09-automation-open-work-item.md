---
title: Automating Work Item Access from Git Branches
date: 2025-02-09 00:00:00 +0100
categories: [Development, Automation]
tags: [powershell, azure-devops, git, automation, productivity]
image:
  path: /assets/img/week202504/colorsTerminal.png
  alt: Azure DevOps automation
---

# Automating Work Item Access from Git Branches

Streamlining Azure DevOps integration with local development environments helps maintain context and reduces context-switching during task transitions.

## The Branch-Work Item Discovery Challenge
- **Lost references**: Difficulty tracing work items across multiple feature branches
- **Manual searching**: Time-consuming navigation in Azure DevOps portal
- **Context switching**: Breaking development flow to find requirement details

## PowerShell Automation Solution
**Script functionality**:
1. Gets current Git branch name using `git rev-parse`
2. Extracts work item ID using regex pattern `[TF](\d+)`
3. Constructs Azure DevOps URL dynamically
4. Opens web browser directly to the work item

**Implementation code**:
```powershell
function Open-WorkItem {
    $branchName = git rev-parse --abbrev-ref HEAD | ForEach-Object { $_.Trim() }
    if ($branchName -match '[TF](\d+)') {
        $workItemId = $matches[1]
        Start-Process "https://dev.azure.com/ProjectName/Q/_workitems/edit/$workItemId"
    }
}
```

| Component       | Function                           |
| --------------- | ---------------------------------- |
| `[TF]`          | Matches ticket type (Task/Feature) |
| `(\d+)`         | Captures numeric work item ID      |
| `$matches[1]`   | Extracts first regex group         |
| `Start-Process` | Launches default browser           |

## Configuration Guide
1. Add function to PowerShell profile (`Microsoft.PowerShell_profile.ps1`)
2. Ensure branch naming contains work item ID prefix:
   - Format examples: `T1234-feature-description` or `F5678-bugfix`
3. Save and reload profile: `. $PROFILE`

## Usage Workflow
1. Checkout feature branch: `git checkout T7890-new-api`
2. Execute command: `Open-WorkItem`
3. Browser opens directly to work item #7890
```
