# Python Interview Questions with Answers

---

## 1. What are Python’s key features?

**Answer:**  
Python is:

- **Interpreted:** No compilation step; executed line by line.
- **Dynamically Typed:** No need to declare variable types.
- **High-Level Language:** Closer to human language, easy to read/write.
- **Object-Oriented:** Supports OOP concepts like classes, inheritance, polymorphism.
- **Extensive Libraries:** Has packages for almost everything (data science, web, DevOps).
- **Cross-Platform:** Runs on Windows, Linux, Mac without major changes.

> **Interview Tip:** Python’s simplicity and ecosystem make it popular in automation, web, AI/ML, and DevOps.  
> Mention its large community and support for rapid prototyping.

---

## 2. What are Python data types? Can you name a few built-in ones?

**Answer:**  
Python has several built-in data types:

- **Numeric:** `int`, `float`, `complex`
- **Sequence:** `list`, `tuple`, `range`
- **Mapping:** `dict`
- **Set types:** `set`, `frozenset`
- **Text type:** `str`
- **Boolean:** `bool`
- **Binary types:** `bytes`, `bytearray`, `memoryview`

> **Interview Tip:**  
> You can explain mutability (e.g., `list` is mutable, `tuple` is immutable).  
> Mention that Python is strongly typed—type errors are caught at runtime.

---

## 3. What is the difference between a list, tuple, and set in Python?

**Answer:**

- **List:** Ordered, mutable, allows duplicates.
- **Tuple:** Ordered, immutable, allows duplicates.
- **Set:** Unordered, mutable, unique elements only, no duplicates.

> **Interview Tip:**  
> Use lists for dynamic collections, tuples for fixed data, sets for uniqueness.  
> Sets are useful for membership tests and removing duplicates.

---

## 4. How is Python memory managed?

**Answer:**  
Python uses:

- **Private Heap Space:** All objects/data structures stored here.
- **Garbage Collector:** Reclaims unused memory automatically (reference counting + cyclic garbage collector).
- **Memory Management APIs:** `gc` module can be used to tweak garbage collection.

> **Interview Tip:**  
> You rarely need to manually manage memory, but understanding reference cycles and memory leaks is important for long-running applications.  
> Mention that memory management is automatic but can be monitored and optimized.

---

## 5. What are Python decorators?

**Answer:**  
A decorator is a function that modifies another function or class without changing its source code.

**Example:**
```python
def decorator(func):
    def wrapper():
        print("Before function")
        func()
        print("After function")
    return wrapper

@decorator
def hello():
    print("Hello")

hello()
```

> **Interview Tip:**  
> Real-world usage includes logging, authentication, caching, retry mechanisms.  
> Decorators help keep code DRY and modular.

---

## 6. What is the difference between shallow copy and deep copy?

**Answer:**

- **Shallow Copy (`copy.copy`):** Creates a new object but references nested objects (changes reflect).
- **Deep Copy (`copy.deepcopy`):** Creates a completely independent copy (nested objects are cloned).

> **Interview Tip:**  
> Shallow copy is faster, but deep copy avoids unexpected side effects.  
> Use deep copy when working with nested or complex objects.

---

## 7. What is Python’s GIL (Global Interpreter Lock)?

**Answer:**  
GIL is a mutex in CPython that allows only one thread to execute Python bytecode at a time.

- Prevents true parallelism in multi-threaded CPU-bound tasks.
- Does not affect I/O-bound tasks (like network or file I/O), where multi-threading still improves performance.

> **Interview Tip:**  
> For CPU-bound tasks, use multiprocessing instead of threading.  
> Mention that alternative Python implementations (Jython, IronPython) do not have GIL.

---

## 8. How does exception handling work in Python?

**Answer:**  
Python uses `try-except-finally-else` blocks:

```python
try:
    x = 10 / 0
except ZeroDivisionError:
    print("Division by zero error")
else:
    print("No error")
finally:
    print("Always executes")
```

> **Interview Tip:**  
> Exception handling ensures graceful program termination and is widely used in robust applications.  
> Always catch specific exceptions and avoid bare `except:`.

---

## 9. What are Python generators and why are they useful?

**Answer:**  
Generators are functions that use `yield` instead of `return`.

- Produce values one at a time (lazy evaluation), instead of storing all in memory.
- Useful for handling large datasets, infinite sequences, or streaming data.

**Example:**
```python
def counter(n):
    for i in range(n):
        yield i
```

> **Interview Tip:**  
> Generators save memory and improve performance in data pipelines, ETL, log processing.  
> Use generator expressions for concise syntax.

---

## 10. How do you manage packages in Python?

**Answer:**

- Use `pip` (Python package manager):  
  `pip install requests`
- Use virtual environments (`venv`, `virtualenv`) to isolate dependencies.
- For advanced workflows: `pipenv` or `poetry` for dependency + environment management.

> **Interview Tip:**  
> In production projects, using `requirements.txt` or `Pipfile` ensures reproducibility.  
> Always activate your virtual environment before running scripts or installing packages.