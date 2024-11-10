---
title: Building Custom Roslyn Analyzers and Code Fixes
date: 2024-06-05 12:00:00 +0100
categories: [.NET, Code Quality]
tags: [csharp, roslyn, code-analysis, analyzers, code-quality]
---

## Tutorial: Write Your First Analyzer and Code Fix

Recently, we explored how to write custom Roslyn analyzers and discussed their potential applications in our daily work. This post summarizes our findings and presents some ideas on how we can leverage Roslyn analyzers to improve our codebase.

### Potential Use Cases for Custom Analyzers

- **Check `ApiConvention` Attribute on Controller Methods**: Ensure that all controller methods have the appropriate `ApiConvention` attribute applied, promoting consistency and adherence to API guidelines.

- **Detect SQL Injection Vulnerabilities**: Analyze code for SQL statements that are missing parameters, helping to catch potential SQL injection risks early in the development process.

- **Enforce Naming Conventions for `qTable` Classes**: Verify that classes representing `qTable` start with a lowercase 'q' and that only those classes use this naming convention, ensuring consistency and reducing confusion in the codebase.

- **Prevent Incorrect Iteration over `QDbStatement`**: Discourage the use of `while` loops when iterating over `QDbStatement` results, and encourage the use of `foreach` loops instead for better readability and maintainability.

#### Example of Discouraged Pattern:

```csharp
var s = new QDbStatement();
IqRecordset r = null;
s.executeQuery("SQL");
while (true)
{
    r = s.fetch();
    if (s.LastResult.endOfData()) { break; }
    ReadRecord(r);
}
```

#### Preferred Approach Using `foreach`:

```csharp
var s = new QDbStatement();
s.executeQuery("SQL");
foreach (var r in s)
{
    ReadRecord(r);
}
```

### Introduction to Roslyn Analyzers

**Roslyn** is the compiler platform for .NET that provides rich code analysis APIs. Roslyn analyzers are tools that inspect your code for potential issues, suggest improvements, and can even offer automatic code fixes.

By writing custom analyzers, you can enforce coding standards, detect code smells, and automate code reviews tailored to your project's specific needs.

### Writing Your First Analyzer and Code Fix

To get started with creating a custom analyzer:

1. **Set Up Your Development Environment**:

   - Install the **.NET Compiler Platform SDK** (Roslyn SDK).
   - Ensure you have Visual Studio 2022 or later.

2. **Create a New Analyzer Project**:

   - Use the **Analyzer with Code Fix (.NET Standard)** project template.
   - This creates a solution with two projects: the analyzer and the unit tests.

3. **Define Your Analyzer Logic**:

   - Override the `Initialize` method to register your analysis actions.
   - Use syntax or semantic models to inspect code elements.

   Example: Detecting methods missing the `ApiConvention` attribute.

   ```csharp
   public override void Initialize(AnalysisContext context)
   {
       context.EnableConcurrentExecution();
       context.ConfigureGeneratedCodeAnalysis(GeneratedCodeAnalysisFlags.None);
       context.RegisterSymbolAction(AnalyzeMethod, SymbolKind.Method);
   }

   private static void AnalyzeMethod(SymbolAnalysisContext context)
   {
       var methodSymbol = (IMethodSymbol)context.Symbol;
       if (!methodSymbol.GetAttributes().Any(attr => attr.AttributeClass.Name == "ApiConventionAttribute"))
       {
           var diagnostic = Diagnostic.Create(Rule, methodSymbol.Locations[0], methodSymbol.Name);
           context.ReportDiagnostic(diagnostic);
       }
   }
   ```

4. **Implement Code Fixes**:

   - Provide suggested fixes for the detected issues.
   - Implement the `CodeFixProvider` class.

   Example: Adding the `ApiConvention` attribute to a method.

   ```csharp
   public override async Task RegisterCodeFixesAsync(CodeFixContext context)
   {
       var root = await context.Document.GetSyntaxRootAsync(context.CancellationToken).ConfigureAwait(false);
       var diagnostic = context.Diagnostics.First();
       var diagnosticSpan = diagnostic.Location.SourceSpan;
       var methodDeclaration = root.FindToken(diagnosticSpan.Start).Parent.AncestorsAndSelf().OfType<MethodDeclarationSyntax>().First();

       context.RegisterCodeFix(
           CodeAction.Create(
               title: "Add ApiConvention attribute",
               createChangedDocument: c => AddAttributeAsync(context.Document, methodDeclaration, c),
               equivalenceKey: "AddApiConvention"),
           diagnostic);
   }

   private async Task<Document> AddAttributeAsync(Document document, MethodDeclarationSyntax methodDecl, CancellationToken cancellationToken)
   {
       var attribute = SyntaxFactory.Attribute(SyntaxFactory.ParseName("ApiConvention"));
       var newMethodDecl = methodDecl.AddAttributeLists(SyntaxFactory.AttributeList(SyntaxFactory.SingletonSeparatedList(attribute)));
       var root = await document.GetSyntaxRootAsync(cancellationToken);
       var newRoot = root.ReplaceNode(methodDecl, newMethodDecl);
       return document.WithSyntaxRoot(newRoot);
   }
   ```

5. **Testing Your Analyzer and Code Fix**:

   - Use the provided unit test project to write tests that validate your analyzer's behavior.
   - Ensure that the analyzer correctly identifies issues and that the code fix applies changes as expected.

### Benefits of Custom Roslyn Analyzers

- **Automated Code Quality Enforcement**: Catch potential issues automatically during development.
- **Consistent Coding Standards**: Enforce project-specific conventions without manual code reviews.
- **Increased Development Efficiency**: Reduce the time spent on repetitive code corrections.
- **Early Detection of Bugs**: Find and fix bugs earlier in the development cycle, reducing costs.

### Resources

- **Official Tutorial**: [Write your first analyzer and code fix](https://learn.microsoft.com/en-us/dotnet/csharp/roslyn-sdk/tutorials/how-to-write-csharp-analyzer-code-fix)
- **Roslyn GitHub Repository**: [dotnet/roslyn](https://github.com/dotnet/roslyn)
- **Roslyn Analyzer Templates**: Available in Visual Studio for creating new analyzers quickly.

### Conclusion

Custom Roslyn analyzers and code fixes are powerful tools for improving code quality and enforcing standards within your team. By tailoring analyzers to your specific needs, you can automate code reviews, prevent common mistakes, and maintain a high-quality codebase.
