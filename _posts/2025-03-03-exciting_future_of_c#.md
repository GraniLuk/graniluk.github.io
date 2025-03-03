---

title: "Exciting future of C#, what's ahead for us"  
date: 2025-03-03 00:00:00 +0100  
categories: [.NET, C#]  
tags: [csharp, type unions, primary constructors, pattern matching]  
image:  
  path: /assets/img/week202504/G.webp  
  alt: Params Collections in C#  

---

In a recent [interview on Nick Chapsas’ YouTube channel](https://www.youtube.com/watch?v=T9UqIkuGnuo), C# Lead Designer Mads Torgersen offered a deep dive into exciting upcoming features in C#, discussing long-standing challenges and potential futures for the language. In this post, we’ll look at three topics that stood out: the dilemma with primary constructors, the vision for type unions, and the interplay between pattern matching and virtual methods.

## Primary Constructors Dilemma

Mads explained that primary constructors were designed to reduce boilerplate by moving parameter declarations directly into the class header, but this comes at a cost.  
> "Primary constructor parameters, if used outside of construction, become part of the object's state (like fields). People want to make their object state readonly, but can't do that directly with primary constructor parameters. The problem is there are two possible features that both involve readonly on primary constructor parameters, but with different meanings:  
>
> - Make the primary constructor parameter a readonly field.  
> - Allow readonly parameters everywhere (including primary constructors).  
>
> These have different semantics (e.g., can you assign to them during construction?). We're not ready to choose."

The issue is that when you define a class with a primary constructor, the parameters automatically create hidden fields that are mutable by default. This behavior contrasts with the common pattern where constructor parameters are explicitly assigned to readonly fields, ensuring immutability and catching accidental state changes at compile time. The dilemma Microsoft faced was whether to make primary constructor parameters automatically readonly, matching the expectation of immutability, or to allow readonly parameters everywhere in the language, which introduces new questions regarding assignment during construction.

For example, compare the two approaches:

```csharp
// Using a primary constructor
public class MyClass1(int myValue)
{
    // 'myValue' is available throughout the class,
    // but it is not declared readonly.
    public void DoSomething() { /* ... */ }
}

// The alternate approach today:
// Using a traditional constructor with explicit readonly assignment
public class MyClass2
{
    private readonly int _myValue;

    public MyClass2(int myValue)
    {
        _myValue = myValue;
    }

    public void DoSomething() { /* ... */ }
}
```

While primary constructors make the syntax more concise, they create a “mixed bag” by introducing potential mutability that many developers want to avoid.

## Type Unions: A New Object-Oriented Approach

The discussion then moved on to type unions—what many of us know as discriminated unions—and how they might evolve in C#. Mads stated:  
> "In C#, unions should be unions of types. You don't have to pattern on a union and get an A and immediately... or you get a Dog and immediately you have to decompose it... You can carry it around as a Dog."

This is a departure from the traditional tagged union approach found in functional languages like F#, where unions are “name–tagged” and require deconstruction immediately. In contrast, the proposed design for C# envisions a union where each alternative is a fully-fledged type in its own right—allowing developers to work in a more object-oriented way. Consider the following envisioned syntax:

```csharp
public union Charge
{
    NightCount(int Count);
    FixedAmount(decimal Amount, CurrencyCode Currency);
    Percentage(decimal Amount);
}

// Usage example:
Charge myCharge = new Charge.NightCount(2);
var description = myCharge switch
{
    Charge.NightCount n   => $"Charging for {n.Count} night(s)",
    Charge.FixedAmount f  => $"Charging a fixed amount of {f.Amount}",
    Charge.Percentage p   => $"Charging a percentage: {p.Amount}%",
};
```

This approach brings the benefits of exhaustive pattern matching—where the compiler can ensure you’ve handled every case—while still maintaining the identity and encapsulation of each type.

## Pattern Matching and Virtual Methods: Two Sides of Type-Dependent Behavior

Mads also compared pattern matching with virtual methods, highlighting how each serves a different aspect of type-dependent behavior in C#.  
> "Pattern matching and virtual methods, they are each other’s corresponding features in functional versus OOP programming. With virtual methods, you define a closed list of operations and allow for an open-ended number of derived types, while pattern matching lets you write a function that exhaustively handles a closed set of types."

In traditional object-oriented programming, you might rely on virtual methods to allow each subclass to implement behavior in its own way. For example:

```csharp
abstract class Shape
{
    public abstract string GetDescription();
}

class Circle : Shape
{
    public double Radius { get; }
    public Circle(double radius) => Radius = radius;
    public override string GetDescription() => $"Circle with radius {Radius}";
}

class Rectangle : Shape
{
    public double Width { get; }
    public double Height { get; }
    public Rectangle(double width, double height)
    {
        Width = width;
        Height = height;
    }
    public override string GetDescription() => $"Rectangle with width {Width} and height {Height}";
}
```

Here, the base class defines which operations (methods) are available, and each derived type provides its own implementation. In contrast, pattern matching shifts the focus from behavior defined on the type to behavior defined by the function that examines the type:

```csharp
public string DescribeShape(Shape shape) => shape switch
{
    Circle c      => $"Circle with radius {c.Radius}",
    Rectangle r   => $"Rectangle with width {r.Width} and height {r.Height}",
    _             => "Unknown shape"
};
```

This style emphasizes an exhaustive check over a known set of cases, making it safer and often more concise when working with union types.

## Conclusion

The interview with Mads Torgersen underscores several exciting ideas for the future of C#. Primary constructors promise more concise syntax at the expense of introducing potential mutability issues, type unions aim to bring a more natural object-oriented approach to discriminated unions, and pattern matching offers a powerful alternative to virtual methods by enforcing exhaustiveness in handling type cases. Together, these innovations highlight the C# team’s effort to blend the best of functional and object-oriented programming into a more expressive language.
