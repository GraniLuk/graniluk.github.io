---

title: "New contextual keyword in c#"  
date: 2025-03-29 00:00:00 +0100  
categories: [.NET, C#]  
tags: [csharp, field, contextual word]  
image:  
  path: /assets/img/week202504/G.webp  
  alt:

---

### New Warning About Contextual Keyword "value"

We recently encountered a new warning in SonarCloud related to the use of `value` as a keyword in property accessors. Initially, it was believed that `value` would become a contextual keyword, causing potential issues. However, after further investigation, it was confirmed that **`value` will not be introduced** as a contextual keyword. Instead, the keyword **`field`** will be used for referencing backing fields in properties.

---

### Summary of the `field` Keyword Feature

The new `field` keyword allows properties to reference an automatically generated backing field without explicitly declaring it. This feature simplifies property definitions, reduces boilerplate code, and keeps the backing field scoped to the accessor bodies.

---

### Motivation

The primary motivation behind this feature is to provide more control within property accessors without the overhead of manually declaring and managing backing fields. This is especially useful for scenarios involving:

- **Lazy initialization or default value handling in getters.**
- **Validation or event raising (e.g., `INotifyPropertyChanged`) in setters.**

By using `field`, developers can reduce code clutter and avoid exposing backing fields unnecessarily.

---

### Examples

1. **Mixing Auto Accessors and Full Accessors**

    ```csharp
    public int Number
    {
        get;
        set => Set(ref field, value);
    }
    ```

2. **Lazy Initialization in Getters**

    ```csharp
    public string LazilyComputed => field ??= Compute();
    ```

3. **Custom Logic in Setters**

    ```csharp
    public string Name
    {
        get => field;
        set
        {
            if (field == value) return;
            field = value;
            OnPropertyChanged();
        }
    }
    ```

---

### Comparison to Existing Syntax

**Without `field` Keyword (Manual Backing Field)**

```csharp
private int _number;
public int Number
{
    get => _number;
    set => _number = value;
}
```

**With `field` Keyword**

```csharp
public int Number
{
    get => field;
    set => field = value;
}
```

---

### Breaking Changes

Introducing `field` as a contextual keyword can be a **breaking change** if a variable named `field` already exists within property accessor bodies. This might occur in various real-world scenarios. For example, in sports-related applications:

```csharp
public string TeamField
{
    get
    {
        var field = GetFootballField(); // 'field' is a legitimate variable name here
        return field.HomeTeam + " Field"; // This would conflict with the new keyword
    }
}
```

To resolve such conflicts, you have two options:
1. Rename the variable to something more specific (e.g., `footballField`)
2. Escape the identifier using `@field` to maintain the original name:

```csharp
public string TeamName
{
    get
    {
        var @field = GetFootballField(); // Using @ prefix to escape the keyword
        return @field.HomeTeam + " Field";
    }
}
```

While the `@` prefix resolves the conflict, consider whether renaming the variable might lead to clearer code in these cases.

---

### Conclusion

The `field` keyword simplifies property implementation and reduces the risk of accidental misuse of backing fields. We should consider how this feature can streamline our code while being mindful of potential breaking changes.

What do you think about the new `field` keyword? Will it simplify your property accessors? Share your thoughts in the comments!

---

**Sources:**
- [C# Language Design](https://github.com/dotnet/csharplang/issues/7964)
