---
title: Understanding Default Interface Methods in .NET 8
date: 2024-02-07 12:00:00 +0100
categories: [.NET, C#]
tags: [dotnet, csharp, interfaces, net8]
---

Default interface methods are a powerful feature introduced in .NET 8 that allows adding new functionality to interfaces without breaking existing implementations. This article explores some interesting behaviors and use cases of this feature.

## Example Implementation

Here's a practical example demonstrating various scenarios with default interface methods:

```csharp
public interface IShape
{
    string GetName() => "IShape";
}

public class Rectangle : IShape
{
}

public class Square : IShape
{
    public string GetName() => nameof(Square); 
}

public class Circle : Rectangle
{
    public string GetName() => nameof(Circle);
}

public class Diamond : Square, IShape
{
    public string GetName() => nameof(Diamond); 
}
```

Test Cases and Behaviors

```csharp
public class Tests
{
    [Test]
    public void WhenGetNameIsAdded_ThenReturnsImplementationFromThisClass()
    {
        Assert.That(GetName(new Square()), Is.EqualTo(nameof(Square)));
    }

    [Test]
    public void WhenGetNameIsNotAdded_ThenDefaultImplementation()
    {
        Assert.That(GetName(new Rectangle()), Is.EqualTo("IShape"));
    }

    [Test]
    public void WhenClassHasGetNameAddedInheritsFromClassWithoutThisMethod_ThenDefaultImplementation()
    {
        Assert.That(GetName(new Circle()), Is.EqualTo("IShape"));
    }

    [Test]
    public void WhenClassHasGetNameAddedInheritsFromClassWithThisMethod_ThenDefaultImplementation()
    {
        Assert.That(GetName(new Diamond()), Is.EqualTo(nameof(Diamond)));
    }

    private string GetName(IShape shape)
    {
        return shape.GetName();
    }
}
```

## Key Findings
An interesting observation is that the Circle class returns the default implementation despite having its own implementation. This highlights some of the subtle complexities when working with default interface methods.

## Usage Recommendations
Default interface methods should be used with caution. They are particularly useful for:

- Adding new functionality to platform packages
- Avoiding forced updates in dependent projects
- Providing backward compatibility
## Source
For more detailed information, visit Andrew Lock's blog post about Default Interface Methods.