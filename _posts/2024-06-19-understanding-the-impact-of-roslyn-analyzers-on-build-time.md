---
title: Understanding the Impact of Roslyn Analyzers on Build Time
date: 2024-06-19 12:00:00 +0100
categories: [Development, .NET]
tags: [csharp, roslyn, analyzers, msbuild, performance]
---

Recently, we analyzed the impact of Roslyn analyzers on the build time of our solution.

![Build Time Analysis](/assets/img/build-time-analysis.png)

As you can see, the **SonarAnalyzers** took a significant amount of time during the build—over **7 minutes**—while the entire build process took **1 minute and 54 seconds**. Since analyzers can run in parallel, this doesn't mean they add exactly 7 minutes to the build time. The actual impact depends on how much the compiler can parallelize the work and the number of available CPU cores. Nevertheless, it's evident that analyzers can have a substantial effect on compilation time.

With these metrics in mind, it's worth considering how to manage analyzers in your projects to balance code quality and build performance. There are three MSBuild properties you can use to control analyzer behavior:

- **`RunAnalyzersDuringBuild`**: Controls whether analyzers run at build time.
- **`RunAnalyzersDuringLiveAnalysis`**: Controls whether analyzers run live in the IDE during design time.
- **`RunAnalyzers`**: Disables analyzers entirely, both at build and design time. This property takes precedence over the other two.

In our project file (`YourProject.csproj`), we had the settings configured as follows:

```xml
<PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|AnyCPU'">
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <WarningsAsErrors>$(WarningsAsErrors);NU1605;CS8618;S1185</WarningsAsErrors>
    <RunAnalyzersDuringBuild>false</RunAnalyzersDuringBuild>
</PropertyGroup>
```

By setting `RunAnalyzersDuringBuild` to `false`, we disabled analyzers during the build process to reduce build times. However, this also means we might miss important code issues until later.

To maintain the benefits of analyzers without impacting build performance, we can enable `RunAnalyzersDuringLiveAnalysis` so that analyzers provide feedback in the IDE while coding:

```xml
<PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|AnyCPU'">
    <DefineConstants>DEBUG;TRACE</DefineConstants>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <RunAnalyzersDuringBuild>false</RunAnalyzersDuringBuild>
    <RunAnalyzersDuringLiveAnalysis>true</RunAnalyzersDuringLiveAnalysis>
</PropertyGroup>
```

With this configuration:

- **Analyzers are disabled during the build**, reducing build time.
- **Analyzers are enabled during live analysis**, allowing developers to see warnings and suggestions in real-time as they write code.

## Optimizing Analyzer Usage

Here are some additional tips to help manage the impact of analyzers on your build process:

### 1. Run Analyzers in CI/CD Pipelines

Consider enabling full analyzer execution in your Continuous Integration (CI) builds. This ensures that code quality checks are enforced before code is merged, without affecting individual developers' build times.

### 2. Fine-Tune Analyzers

- **Disable Unnecessary Rules**: Review the analyzer rules and disable any that are not relevant to your project.
- **Adjust Severity Levels**: Modify the severity of rules to focus on critical issues. This can be done using the 

.editorconfig

 file.

### 3. Use Rule Sets or EditorConfig

Leverage rule sets or the 

.editorconfig

 file to customize which analyzers run and how they report issues:

```ini
# .editorconfig example
[*.cs]
dotnet_analyzer_diagnostic.category-performance.severity = warning
dotnet_analyzer_diagnostic.category-style.severity = suggestion
```

### 4. Analyze Specific Configurations

Enable analyzers for specific build configurations, such as `Release`, where build time is less critical:

```xml
<PropertyGroup Condition="'$(Configuration)' == 'Release'">
    <RunAnalyzersDuringBuild>true</RunAnalyzersDuringBuild>
</PropertyGroup>
```

## Conclusion

Roslyn analyzers are powerful tools for improving code quality and catching potential issues early in the development process. However, they can impact build performance if not managed carefully. By configuring analyzer settings in your project files and leveraging live analysis in the IDE, you can strike a balance between maintaining high code quality and efficient build times.

---

**References**:

- [Understanding the Impact of Roslyn Analyzers on the Build Time](https://www.meziantou.net/understanding-the-impact-of-roslyn-analyzers-on-the-build-time.htm)
- [MSBuild Properties for Controlling Analyzers](https://learn.microsoft.com/en-us/visualstudio/code-quality/use-roslyn-analyzers?view=vs-2022#control-analyzer-execution)