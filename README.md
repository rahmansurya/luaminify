# 🛠️ MIGII-MINIFIER

<p align="center">
  <img src="https://img.shields.io/badge/Language-Lua-blue.svg" alt="Lua">
  <img src="https://img.shields.io/badge/Version-1.2.0-green.svg" alt="Version">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-brightgreen.svg" alt="Maintained">
</p>

<p align="center">
  <strong>Parabot Lua paling <i>gercep</i> pikeun ngatur kode sangkan rapih tur hampang.</strong><br>
  Didesain husus pikeun scripter Roblox anu hoyong optimasi kodingan sacara instan.
</p>

---

## 📖 Naon ieu téh?

**MIGII-MINIFIER** nyaéta *tool* sederhana tapi *powerful* anu fungsina pikeun ngolah file `.lua`. Parabot ieu bisa ngarobah kode anu acak-acakan jadi rapih (Unminify) atawa sabalikna, ngompres kode jadi sakalimat sangkan leutik ukuranana (Minify).

## 🌟 Fitur Utama

* ✨ **Auto-Indentation**: Ngatur jorokan (tab) sacara otomatis dumasar kana logika `function`, `if`, `do`, jeung `repeat`.
* ⚡ **Smart Minify**: Ngahapus komentar jeung spasi anu teu perlu sangkan script leuwih *fast-load*.
* 🎨 **Operator Padding**: Masihan rohang (spasi) dina operator kawas `==`, `..`, jeung `=` sangkan kodingan langkung "bernafas".
* 📂 **Automatic Naming**: Hasilna otomatis disimpen kalayan nami `_mini.lua` atawa `_unmini.lua`.

---

## 🚀 Cara Maké

Pastikeun anjeun parantos masang **Lua Interpreter** dina sistem anjeun.

### 📥 Ngompres Kode (Minify)
Gunakeun paréntah ieu pikeun ngaleutikan ukuran file:
```bash
lua minify.lua minify rock.lua
```
Output: rock_mini.lua

🛠️ Ngarapihkeun Kode (Unminify)

Gunakeun paréntah ieu pikeun ngabongkar kode anu "numpuk" sangkan gampil dibaca:

```bash
lua minify.lua unminify rock.lua
```

Output: rock_unmini.lua

