---
title: Checking Your Solution for NuGet Vulnerabilities or Deprecated Packages
date: 2024-05-08 12:00:00 +0100
categories: [Development, .NET]
tags: [nuget, security, vulnerabilities, dotnet, packages]
---

While your software might be the best in the world, it's only as good as the libraries it depends on. In this post, we'll explore how to check your .NET solution for NuGet vulnerabilities or deprecated packages to enhance your application's security.

## Motivation

Even if you check your own code for common issues like Cross-Site Scripting (XSS) and SQL Injection, the libraries you use might have vulnerabilities or be deprecated. Attackers could exploit these weaknesses through supply chain attacks to inject malicious code into your software.

## What is a Supply Chain Attack?

A supply chain attack is a cyber-attack that targets less-secure elements in the supply chain, such as third-party packages. By compromising these dependencies, attackers can indirectly affect your software.

## How to Check for Vulnerabilities

You can use the .NET CLI to check your solution for vulnerable or deprecated packages automatically:

```bash
dotnet list package --vulnerable
```

This command will list any packages with known vulnerabilities. For example:

```
The following sources were used:
   https://api.nuget.org/v3/index.json
   https://ci.appveyor.com/nuget/benchmarkdotnet

Project `Vulnerable` has the following vulnerable packages
   [net8.0]: 
   Top-level Package            Requested   Resolved   Severity   Advisory URL                                     
   > System.Data.SqlClient      4.8.5       4.8.5      High       https://github.com/advisories/GHSA-98g6-xh36-x2p7
```

## Automate Checks with CI/CD

Unfortunately, the dotnet list package command always returns an exit code of 0, even when vulnerabilities are found, which makes it challenging to use directly in a CI/CD pipeline. However, you can utilize tools like grep to parse the output and fail the build if vulnerabilities are detected.

Here's an example using GitHub Actions:

``` 
- name: Check for vulnerable packages
  run: |
    set -e
    OUTPUT=$(dotnet list package --vulnerable)
    echo "$OUTPUT"
    if echo "$OUTPUT" | grep -q 'no vulnerable packages'; then
      echo "No vulnerable packages found"
    else
      if echo "$OUTPUT" | grep -q 'vulnerable'; then
        echo "Vulnerable packages found"
        exit 1
      fi
    fi
```

This script:

* Runs dotnet list package --vulnerable and stores the output.
* Checks if the output contains 'no vulnerable packages'.
* If vulnerabilities are found, it exits with a non-zero code to fail the build.
## Conclusion

Regularly checking for vulnerabilities in your dependencies is crucial for maintaining the security of your applications. By automating these checks in your CI/CD pipeline, you can catch issues early and mitigate risks associated with supply chain attacks.