# 🧾 SimpleRegistry – Testnet Deployment & Documentation

A simple decentralized registry system for unique names, written in Solidity. It uses `EnumerableSet` from OpenZeppelin to store and manage user-claimed names efficiently. This project includes a full suite of Foundry-based unit tests and emits events on name registration and release.

---

## 🚀 Overview

**SimpleRegistry** allows users to:
- Register unique names (case-sensitive).
- Release their claimed names.
- Retrieve registered names.
- Query the number of total registered names.
- View usernames associated with any address.

---

## 📦 Tech Stack

| Tool/Library              | Description                                            |
|---------------------------|--------------------------------------------------------|
| **Solidity ^0.8.19**      | Smart contract programming language                    |
| **OpenZeppelin Contracts**| Used for `EnumerableSet` utility for managing name sets|
| **Foundry**               | Smart contract testing framework via `forge-std/Test.sol` |
| **Ethereum Stack Exchange** | Research for string ↔ `bytes32` conversions and best practices with `EnumerableSet` |

---

## 📚 Key References Used

- 🔁 [How to convert a string to `bytes32`](https://ethereum.stackexchange.com/questions/9142/how-to-convert-a-string-to-bytes32)
- 🔁 [How to convert a `bytes32` to string](https://ethereum.stackexchange.com/questions/2519/how-to-convert-a-bytes32-to-string)
- 📖 [Exploring `EnumerableSet` in OpenZeppelin](https://medium.com/@daneelkent/exploring-enumerableset-in-openzeppelin-how-where-and-when-to-use-it-f21afdcbc8b5)

---

## 🧪 Tests (Foundry)

Located in `test/SimpleRegistryTest.t.sol`

### Test Coverage:
- ✅ Add a name
- ✅ Prevent duplicate name registration
- ✅ Emit `NameAdded` and `NameReleased` events
- ✅ Release registered names
- ✅ Handle unregistered name errors
- ✅ Query username by address
- ✅ Validate string length (max 32 bytes)
- ✅ Return total number of names

### Commands:
```bash
forge install openzeppelin/openzeppelin-contracts
forge build
forge test -vvvv
