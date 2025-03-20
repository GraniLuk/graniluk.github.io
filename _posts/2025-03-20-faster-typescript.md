---

title: "TypeScript is Moving to Go – Here’s What You Need to Know!"  
date: 2025-03-20 00:00:00 +0100  
categories: [.NET, TypeScript]  
tags: [typescript, rust, performance]  
image:  
  path: /assets/img/week202504/rocket.png 
  alt: competition between languages

---

### The Big News: TypeScript Goes Native

Microsoft just dropped a bombshell: TypeScript is getting **10x faster** with a new native compiler, and here’s the kicker—it’s being rewritten in **Go**. Yes, you read that right. Not Rust, not C#, but Go.

If you’ve ever worked on a large TypeScript codebase in VS Code, you know this is a big deal. The new compiler promises drastic improvements in speed and memory efficiency. Let’s break down why Microsoft made this choice and what it means for you.

---

### Why Is TypeScript Being Rewritten?

**Performance, scalability, and developer experience.**

TypeScript is beloved by developers for its static typing and tooling support, but it struggles with large codebases. Compilation and type-checking times can become painfully slow, making developer workflows sluggish.

To put it in numbers:

| Codebase   | Lines of Code | Current Compilation Time | New Go Compiler | Speedup |
| ---------- | ------------- | ------------------------ | --------------- | ------- |
| VS Code    | 1.5M          | 77.8s                    | 7.5s            | 10.4x   |
| RxJS       | 2,100         | 1.1s                     | 0.1s            | 11.0x   |
| Playwright | 356,000       | 11.1s                    | 1.1s            | 10.1x   |

This is game-changing. Faster builds, snappier editor performance, and a smoother developer experience.

---

### Why Go and Not Rust or C#?

The internet (especially Rust fans) has been buzzing with this question. Microsoft had solid reasons for choosing Go over Rust or even C#:

1. **Portability & Ease of Migration** – TypeScript’s current compiler is deeply tied to JavaScript paradigms. Porting it to Rust would require rewriting fundamental structures and potentially “rolling their own garbage collector.” Go, on the other hand, makes the transition much smoother.

2. **Simplicity & Developer Experience** – Go’s simplicity, garbage collection, and ease of learning made it a practical choice. Rust, while powerful, would introduce a steeper learning curve for existing TypeScript maintainers.

3. **Concurrency & Performance** – While Rust is known for its speed, Go’s performance in this case is close enough to Rust that the additional complexity wasn’t worth it. Microsoft’s testing found that single-core performance was within the margin of error between the two languages.

4. **Fast Native Compilation** – Unlike C#, which relies on the .NET runtime, Go compiles to native executables out of the box. This ensures TypeScript’s new compiler can run efficiently on any platform.

---

### What Does This Mean for Developers?

- **Massive Speed Boost** – Expect your TypeScript projects to compile and type-check significantly faster.
- **Better Editor Performance** – Large projects will load and respond quicker in VS Code and other editors.
- **More Room for AI & Refactoring Features** – With a lighter compiler, TypeScript can integrate deeper AI-powered coding assistance.
- **Same TypeScript, New Compiler** – TypeScript’s syntax and functionality remain unchanged, so no breaking changes in your code.

The first preview of the Go-based TypeScript compiler is expected **mid-2025**, with a full release by the end of the year. If you’re eager to test it, Microsoft has already opened a **working repo** with early builds.

---

### Final Thoughts

Microsoft’s move to Go is a pragmatic choice aimed at **developer productivity** rather than raw theoretical performance. The trade-offs make sense, and the speed improvements are undeniable. Rust fans might not be thrilled, but at the end of the day, **we’re getting a TypeScript compiler that’s 10x faster**—and that’s a win for everyone.

What do you think? Would you have chosen Go, or do you think Rust or C# would have been better? Drop your thoughts in the comments!

---

**Sources:**
- [Microsoft Dev Blog](https://devblogs.microsoft.com/typescript/typescript-native-port/)
- [Community Discussions on Reddit](https://www.reddit.com/r/programming/comments/1j8s40n/comment/mh7n5n0/)

