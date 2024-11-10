---
title: Exploring Primary Constructors in C# 12
date: 2024-05-08 12:00:00 +0100
categories: [.NET, C#]
tags: [csharp, .NET, primary-constructors, coding]
---

C# 12 introduces a new feature called **primary constructors** for classes. This feature simplifies the initialization of class fields and reduces boilerplate code by allowing parameters to be declared directly in the class declaration.

## Before Primary Constructors

Consider the traditional way of initializing fields through a constructor:

```csharp
namespace Example.Worker.Service
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;

        public Worker(ILogger<Worker> logger)
        {
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                if (_logger.IsEnabled(LogLevel.Information))
                {
                    _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                }
                await Task.Delay(1000, stoppingToken);
            }
        }
    }
}
```

In this example, we have a private field _logger that is assigned in the constructor.

## After Introducing Primary Constructors

With primary constructors, you can declare constructor parameters directly in the class definition, eliminating the need for explicit field declarations and a constructor:

```csharp
namespace Example.Worker.Service
{
    public class Worker(ILogger<Worker> logger) : BackgroundService
    {
        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                if (logger.IsEnabled(LogLevel.Information))
                {
                    logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                }
                await Task.Delay(1000, stoppingToken);
            }
        }
    }
}
```
In this refactored code:

* The `ILogger<Worker>` logger parameter is declared directly in the class declaration.
* The `_logger` field and the constructor are removed.
* The `logger` parameter is available throughout the class.

This makes the code more concise and improves readability. The logger instance is accessible within the class scope without the need for additional field declarations.

## Important Considerations

While primary constructors reduce boilerplate, there are some nuances to be aware of:

* **Field Mutability**: Primary constructor parameters for non-record classes are not implicitly readonly. If you need the behavior of readonly fields, you should explicitly declare them.

For example:

```csharp
namespace Example.Worker.Service;

public class Worker(ILogger<Worker> logger) : BackgroundService
{
    private readonly ILogger<Worker> _logger = logger;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            if (_logger.IsEnabled(LogLevel.Information))
            {
                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
            }
            await Task.Delay(1000, stoppingToken);
        }
    }
}
```

In this version:

* A private `readonly` field `_logger` is declared and initialized with the `logger` parameter.
* This ensures that `_logger` cannot be modified after construction, maintaining the immutability of the field.

## Differences Between Classes and Records
It's important to note that primary constructors behave differently in classes and records:

```csharp
public class UserClass(int id, string name, string email);

public record UserRecord(int id, string name, string email);

var userClass = new UserClass(1, "John", "john@example.com");
// userClass.id; // Error: 'UserClass' does not contain a definition for 'id'

var userRecord = new UserRecord(1, "John", "john@example.com");
Console.WriteLine(userRecord.id); // Outputs: 1
```
In this example:

* For `UserRecord`, the parameters become public properties accessible outside the class.
* For `UserClass`, the parameters are not automatically exposed as properties, and attempting to access them directly will result in a compilation error.

To expose parameters in a class, you need to define properties explicitly.

## Initialization vs. Capture
Primary constructors can be used for both initialization and capturing parameters:

### Initialization
Assigning constructor parameters to fields or properties.

```csharp
public class User(string email)
{
    private string _email = email;
}
```
### Capture
Using constructor parameters directly within methods or property definitions.

```csharp
public class User(string email)
{
    public string Email => email;
}
```

Be cautious when mixing initialization and capture, as it can lead to unexpected behaviors.

### Potential Pitfalls
Consider the following code:

```csharp
public class User(string email)
{
    public string Email { get; set; } = email;
    public override string ToString() => email;
}

var user = new User("email@gmail.com");
user.Email = "email@outlook.com";
Console.WriteLine(user.Email);      // Outputs: email@outlook.com
Console.WriteLine(user.ToString()); // Outputs: email@gmail.com
```

In this example:

* The `Email` property is initialized with `email`, but since it's a writable property, it can be changed.
* The `ToString()` method continues to use the original `email` parameter, not the updated `Email` property.
* This can lead to inconsistencies and bugs.

## Conclusion

Primary constructors in C# 12 offer a powerful way to simplify class construction and reduce boilerplate code. However, it's essential to understand their behavior and use them thoughtfully to avoid potential issues.