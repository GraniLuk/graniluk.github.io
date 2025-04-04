---

title: The C# Extensions Dilemma: Designing Syntax for "Extension All the Things"
date: 2025-04-05 00:00:00 +0100  
categories: [.NET, C#]  
tags: [csharp, extensions, architecture]  
image:  
  path: /assets/img/week202504/thinkingDev.webp  
  alt: thinking developer

---

# The C# Extensions Dilemma: Designing Syntax for "Extension All the Things"

**C# 14 will finally let you create extension properties, indexers, and static members—not just methods.** The C# team faced a challenging design problem: how to evolve the syntax without breaking existing code or creating a mess. This post reveals the three competing approaches they considered and why the final design offers the best balance of compatibility and power.

## The Long-Standing Request

Since C# 3.0 introduced extension methods, developers have consistently asked for more:
- "What about extension properties?"
- "Can we make extension methods static?"
- "How about extension indexers?"

The C# team's typical response was that it "shouldn't be so hard," but previous attempts had failed. Now, with a small team (just "one and a half people"), they're finally tackling this challenge for C# 14, though the complete feature will likely roll out incrementally across multiple releases.

## Why Is This Difficult? The Hidden Problem with Extension Methods

To understand the design challenge, we need to examine why extending the current extension method syntax to other member types proved difficult. The current syntax combines two distinct concepts:

```csharp
public static IEnumerable Select(
    this IEnumerable source, // Extension-specific part
    Func selector    // Regular parameter
)
```

This signature contains:
1. **Extension-specific elements**: The `this` modifier and the type being extended
2. **Instance-like signature**: The method name, parameters, and return type

If we could separate these concerns, extending to other member types would be straightforward. Each extension member could simply look like its instance counterpart, with the "extension stuff" specified elsewhere.

## Three Competing Approaches (And Why Two Failed)

### ❌ Approach 1: Per-Member Extension Specification

The first approach considered was attaching extension information to each member declaration:

```csharp
// Verbose and hard to read
public static extension for List<T>
    int DoubledCapacity
    {
        get => this.Capacity * 2;
    }
```

**Drawbacks:**
- Extremely verbose
- Poor readability (you'd need to read far into the line to determine the member type)
- Unclear placement relative to other modifiers
- Visually cluttered with angle brackets and parentheses

### ❌ Approach 2: Type-Level Extension Declarations

```csharp
// New type of declaration
public extension MyEnumerableExtensions for IEnumerable
{
    // Members inside implicitly extend IEnumerable
    public T FirstOrDefault() { /* ... */ }
    public int Count() { /* ... */ }
}
```

**Drawbacks:**
- Departed from the familiar static class model
- Would force libraries with extensions for multiple types (like LINQ with 14 different receiver types) to create numerous separate extension declarations
- Provided no compatible migration path from existing extension methods
- Would force developers to either maintain two separate extension systems or break compatibility

### ✅ Approach 3: Nested Extension Declarations

The winning approach came from a community member named Joseph, who suggested an intermediate layer:

```csharp
public static class MyCollectionExtensions
{
    // Keep using static classes (maintaining compatibility)
    
    // New nested 'extension' declaration for a specific type
    extension IEnumerable source
    {
        // Members inside extend IEnumerable
        public int Count
        {
            get
            {
                int count = 0;
                foreach (var item in source)
                {
                    count++;
                }
                return count;
            }
        }

        public T FirstOrDefault()
        {
            foreach (var item in source)
            {
                return item;
            }
            return default;
        }
    }
}
```

This approach:
- Clearly separates extension specification from member declarations
- Maintains compatibility with existing extension methods
- Avoids the naming proliferation issues of Option 2
- Avoids the syntactic clutter of Option 1
- Provides a migration path for existing code

The main drawback is the extra level of nesting, which might feel unnecessary when a static class contains extensions for only one type. The team is considering potential future shorthands to address this.

## The Parameter vs. 'this' Debate

Another dilemma was how to reference the extended object within member bodies. Should developers use:

1. The parameter name specified in the extension declaration (e.g., `source`)
2. The `this` keyword (as in regular instance members)

The team chose the parameter name approach for consistency with existing extension methods and to facilitate migration. This prioritizes continuity with the established extension method feature, even though it diverges from how instance members work.

## Disambiguation Challenge

The team is still working on a universal syntax for disambiguate between instance members and extension members when they conflict. Unlike extension methods (which can be called using static syntax), it's not obvious how to provide a similar mechanism for properties or indexers.

## Backward Compatibility

Existing extension methods will continue to function exactly as they do today. The new syntax for extension members is designed to complement, not replace, the current model. This means:
- No changes are required to existing extension methods.
- Libraries using old-style extensions can continue to work alongside new-style extensions.

## Mixing Old and New Syntax

The new syntax introduces a nested `extension` declaration within static classes to define additional members for a specific type. This allows developers to mix old-style extension methods with new-style extension members in the same static class:

```csharp
public static class MyExtensions
{
    // Old-style extension method
    public static int WordCount(this string str) => str.Split().Length;

    // New-style extension property
    extension string str
    {
        public int LengthSquared => str.Length * str.Length;
    }
}
```

This approach ensures that developers can gradually adopt the new syntax while maintaining compatibility with existing code.


## Looking Forward: Constructors, Operators, and More

The vision extends to other member types:
- Extension constructors (functioning more like factory methods)
- Extension operators (particularly useful for mathematical operations on collections)
- Potentially extension user-defined conversions (though these remain controversial)

## Conclusion

The design process for "Extension All the Things" illustrates the complex trade-offs language designers must navigate. They must balance innovation with compatibility, simplicity with power, and consistency with practicality. The nested extension declaration approach represents a thoughtful compromise that maintains C#'s commitment to backward compatibility while opening new possibilities for code organization and API design.

As C# 14 approaches, we'll see how this feature evolves based on community feedback and implementation experience. The incremental rollout strategy ensures that the most valuable extension types will be prioritized, with the full vision potentially spanning multiple releases.

What do you think of this approach? Would you have chosen differently? Share your thoughts in the comments!
