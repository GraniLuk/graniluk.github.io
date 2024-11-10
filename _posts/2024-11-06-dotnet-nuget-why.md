---
title: Dotnet Nuget Why - Track Down Package Dependencies
date: 2024-11-06 15:00:00 +0100
categories: [.NET, Nuget]
tags: [.net, nuget, dependencies]
image:
  path: /assets/img/week202446/nugetWhy.png
  alt: dotnet nuget why command output
---

We had a problem last week to find out why specific project has reference to IdentityServer4, it wasn't added as direct reference to this project, but it was transient reference. Easiest way to verify it, is `dotnet nuget why` command:

![dotnet nuget why command output](/assets/img/week202446/nugetWhy.png)

## Source
For more details about the `dotnet nuget why` command, check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-nuget-why). 
