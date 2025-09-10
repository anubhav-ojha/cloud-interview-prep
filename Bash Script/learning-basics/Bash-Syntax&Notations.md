# Bash Syntax & Notations

---

## 1. Numeric Comparison Operators

| Operator | Meaning               | Example                |
| -------- | --------------------- | ---------------------- |
| `-eq`    | equal to              | `[ 5 -eq 5 ]` → true   |
| `-ne`    | not equal to          | `[ 5 -ne 3 ]` → true   |
| `-lt`    | less than             | `[ 3 -lt 5 ]` → true   |
| `-le`    | less than or equal    | `[ 5 -le 5 ]` → true   |
| `-gt`    | greater than          | `[ 10 -gt 3 ]` → true  |
| `-ge`    | greater than or equal | `[ 10 -ge 10 ]` → true |

**Example:**
```bash
num=10
if [ $num -gt 5 ]; then
    echo "$num is greater than 5"
fi
```

---

## 2. String Comparison Operators

| Operator | Meaning                      | Example                    |
| -------- | ---------------------------- | -------------------------- |
| `=`      | equal                        | `[ "$a" = "$b" ]`          |
| `!=`     | not equal                    | `[ "$a" != "$b" ]`         |
| `<`      | less than (lexicographic)    | `[[ "apple" < "banana" ]]` |
| `>`      | greater than (lexicographic) | `[[ "zoo" > "apple" ]]`    |
| `-z`     | string is empty              | `[ -z "$str" ]`            |
| `-n`     | string is not empty          | `[ -n "$str" ]`            |

**Example:**
```bash
name="Anubhav"
if [ -n "$name" ]; then
    echo "Name is not empty"
fi
```

---

## 3. File Test Operators

| Operator  | Meaning                           |
| --------- | --------------------------------- |
| `-e file` | file exists                       |
| `-f file` | file exists and is a regular file |
| `-d file` | file exists and is a directory    |
| `-r file` | file is readable                  |
| `-w file` | file is writable                  |
| `-x file` | file is executable                |
| `-s file` | file exists and is not empty      |

**Example:**
```bash
file="/etc/passwd"
if [ -f "$file" ]; then
    echo "File exists"
else
    echo "File missing"
fi
```

---

## 4. Logical Operators

| Operator | Meaning | Example                                 |
| -------- | ------- | --------------------------------------- |
| `&&`     | AND     | `[ $a -gt 5 ] && [ $b -lt 10 ]`         |
| `\|\|`   | OR      | `[ $a -eq 1 ] || [ $b -eq 2 ]`          |
| `!`      | NOT     | `[ ! -f file.txt ]`                     |

**Example:**
```bash
age=25
if [ $age -gt 18 ] && [ $age -lt 30 ]; then
    echo "Valid age group"
fi
```

---

## 5. Special Notations

| Notation | Description                      |
| -------- | -------------------------------- |
| `$?`     | exit code of last command        |
| `$$`     | current script’s process ID      |
| `$0`     | script name                      |
| `$1, $2…`| positional arguments             |
| `$@`     | all arguments as list            |
| `$#`     | number of arguments              |

---