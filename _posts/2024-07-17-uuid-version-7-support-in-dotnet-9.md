---
title: UUID Version 7 Support in .NET 9
date: 2024-07-17 12:00:00 +0100
categories: [Development, .NET]
tags: [UUID, GUID, .NET 9, C#, Development]
---

## UUID v7 in .NET 9

With the release of .NET 9 Preview 7, Microsoft introduces native support for UUID version 7 (UUID v7), expanding the capabilities of the `System.Guid` class beyond the traditional UUID v4 provided by `Guid.NewGuid()`. This new feature brings significant advantages, particularly when working with databases and distributed systems.

### Key Features of UUID v7

1. **Native Support in .NET 9**: UUID v7 is now natively supported in .NET 9, alongside the existing UUID v4. This allows developers to generate UUIDs that include timestamp information.

2. **New API Methods**: The `System.Guid` class includes new methods for creating UUID v7 instances:

   ```csharp
   var guid = Guid.CreateVersion7();
   var guidWithTimestamp = Guid.CreateVersion7(DateTimeOffset.UtcNow);
   ```

3. **Timestamp Inclusion**: The primary advantage of UUID v7 is the inclusion of a timestamp. This feature enables UUIDs to be roughly sortable by creation time, making them more suitable for database indexing and ordering compared to UUID v4.

4. **UUID v7 Structure**:
   - **48-bit Timestamp**: Represents the number of milliseconds since UNIX epoch (1970-01-01).
   - **12-bit Random**: Adds randomness to prevent collisions within the same millisecond.
   - **62-bit Random**: Provides additional entropy.
   - **Version and Variant**: 6 bits reserved for version and variant information.

   This structure provides 122 bits of entropy, ensuring uniqueness while allowing for temporal sorting.

5. **Customizable Timestamp**: By passing a `DateTimeOffset` to `CreateVersion7`, developers can control the timestamp used in the UUID. This is particularly useful when using a `TimeProvider`, which can be beneficial in testing scenarios:

   ```csharp
   var uuid = Guid.CreateVersion7(timeProvider.GetUtcNow());
   ```

### Benefits of Using UUID v7

- **Temporal Sorting**: UUID v7 allows for UUIDs to be sorted chronologically, which is advantageous for database entries that require ordering based on creation time.

- **High Entropy and Uniqueness**: With 122 bits of randomness, UUID v7 ensures a very low probability of collisions.

- **Compatibility**: UUID v7 maintains the standard UUID format, ensuring compatibility with systems that expect UUIDs.

### Usage Example

Here's an example of generating a UUID v7 and using it in a database context:

```csharp
// Generating a UUID v7
var newId = Guid.CreateVersion7();

// Assuming an entity with an Id property
var newEntity = new MyEntity
{
    Id = newId,
    // Other properties
};

// Saving to the database
dbContext.MyEntities.Add(newEntity);
dbContext.SaveChanges();
```

### Comparison with UUID v4

UUID v4 generates completely random UUIDs, which means they cannot be sorted chronologically. This can lead to fragmentation in database indexes and reduced performance. UUID v7 addresses this issue by incorporating a timestamp, improving index performance due to sequential ordering.

### Points to Consider

- **Clock Sequence Collision**: While UUID v7 includes a timestamp, it's important to be aware of potential collisions when generating multiple UUIDs within the same millisecond. The included random bits mitigate this risk.

- **Time Zones**: The timestamp is based on UTC time. Ensure that any input `DateTimeOffset` values are in UTC to avoid inconsistencies.

### Conclusion

The introduction of UUID v7 in .NET 9 is a significant enhancement for developers needing time-ordered unique identifiers. It combines the benefits of UUIDs with the ability to sort based on creation time, making it ideal for database applications and distributed systems.

---

**References**:

- [UUID v7 in .NET 9](https://steven-giesel.com/blogPost/ea42a518-4d8b-4e08-8f73-e542bdd3b983)
- [.NET 9 Preview Release Notes](https://devblogs.microsoft.com/dotnet/announcing-dotnet-9-preview-7/)
- [RFC 4122: UUID URN Namespace](https://www.rfc-editor.org/rfc/rfc4122)
